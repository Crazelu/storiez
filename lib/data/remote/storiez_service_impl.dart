import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:steganograph/steganograph.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/data/remote/image_service.dart';
import 'package:storiez/data/remote/storiez_service.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/utils/utils.dart';

class StoriezServiceImpl implements StoriezService {
  late final _logger = Logger(StoriezServiceImpl);
  late LocalCache _localCache;
  late final FirebaseAuth _authInstance = FirebaseAuth.instance;
  late final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  late ImageService _imageService;
  Timer? _timer;

  static const _usersCollection = "users";
  static const _storiesCollection = "stories";

  StoriezServiceImpl({
    required LocalCache localCache,
    required ImageService imageService,
  }) {
    _localCache = localCache;
    _imageService = imageService;
    _scheduleStoryDeletion();
  }

  void _scheduleStoryDeletion() {
    try {
      _logger.log("Scheduling story deletion job");
      _timer = Timer.periodic(
        const Duration(seconds: 30),
        (timer) {
          runStoryDeletionJob();
        },
      );
    } catch (e) {
      _logger.log(e);
    }
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw const ApiErrorResponse(message: "Login failed");

      final appUser = await getUser(user.uid);

      if (appUser == null) {
        throw const ApiErrorResponse(message: "Login failed");
      }

      final lastUserId = await _localCache.getUserId();
      final privateKey = await _localCache.getPrivateKey();
      final publicKey = await _localCache.getPublicKey();

      if (lastUserId == user.uid &&
          privateKey.isNotEmpty &&
          publicKey.isNotEmpty) {
        await _localCache.persistLoginStatus(true);
        return;
      }

      await _localCache.saveUserId(user.uid);

      //generate keypair
      final keypair = Steganograph.generateKeypair();

      await _localCache.saveKeys(
        privateKey: keypair.privateKey,
        publicKey: keypair.publicKey,
      );

      //update user
      await updateUserPublicKey(
        documentReferenceId: appUser.docId,
        publicKey: keypair.publicKey,
      );

      await _localCache.persistLoginStatus(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw const ApiErrorResponse(
          message: 'No user found for that email. Sign up instead.',
        );
      } else if (e.code == 'wrong-password') {
        throw const ApiErrorResponse(message: 'Incorrect password');
      } else {
        throw ApiErrorResponse(message: e.message ?? "Login failed");
      }
    } catch (e, trace) {
      _logger.log(e);
      _logger.log(trace);
      throw const ApiErrorResponse(message: "Login failed");
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final credential = await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw const ApiErrorResponse(message: "Signup failed");

      await _localCache.saveUserId(user.uid);

      //generate keypair
      final keypair = Steganograph.generateKeypair();

      await _localCache.saveKeys(
        privateKey: keypair.privateKey,
        publicKey: keypair.publicKey,
      );

      final ref = _firestoreInstance
          .collection(_usersCollection)
          .withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromMap(
              snapshot.data()!,
            ),
            toFirestore: (user, _) => user.toMap(),
          );

      await ref.add(
        AppUser(
          id: user.uid,
          email: email,
          username: username,
          publicKey: keypair.publicKey,
        ),
      );

      await _localCache.persistLoginStatus(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw const ApiErrorResponse(
            message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw const ApiErrorResponse(
          message: 'An account already exists for that email. Log in instead.',
        );
      } else {
        throw ApiErrorResponse(message: e.message ?? "Signup failed");
      }
    } catch (e, trace) {
      _logger.log(e);
      _logger.log(trace);
      throw const ApiErrorResponse(message: "Signup failed");
    }
  }

  @override
  Future<void> runStoryDeletionJob([List<Story> stories = const []]) async {
    try {
      _logger.log("Running story deletion job with args: $stories");
      final now = DateTime.now();

      List<Map<String, String>> savedStories = [];

      if (stories.isNotEmpty) {
        savedStories =
            List<Map<String, String>>.from(stories.map((e) => e.toMap(true)));
      } else {
        savedStories = _localCache.getSavedStories();
      }

      _logger.log(savedStories);

      for (var story in savedStories) {
        final date = DateTime.parse(story["uploadTime"]!);

        final duration = now.difference(date);

        if (duration.inHours >= 24) {
          final ref = _firestoreInstance
              .collection(_storiesCollection)
              .withConverter<Story>(
                fromFirestore: (snapshot, _) => Story.fromMap(
                  snapshot.data()!,
                ),
                toFirestore: (story, _) => story.toMap(),
              );

          Story? remoteStory;
          final documentRef = ref.doc(story["id"]!);
          documentRef.get().then((value) => remoteStory = value.data());

          if (remoteStory != null) {
            await _imageService.deleteImage(remoteStory!.imageUrl);
          }

          await documentRef.delete().onError((error, stackTrace) => null);
        }
      }
    } catch (e) {
      _logger.log(e);
    }
  }

  @override
  Future<String> uploadImage(File image) async {
    try {
      _logger.log("Start image upload");
      return await _imageService.uploadImage(image);
    } catch (e) {
      _logger.log(e);
      throw const ApiErrorResponse(message: "Image upload failed");
    }
  }

  @override
  Future<void> uploadStory(Story story) async {
    try {
      final ref = _firestoreInstance
          .collection(_storiesCollection)
          .withConverter<Story>(
            fromFirestore: (snapshot, _) => Story.fromMap(
              snapshot.data()!,
            ),
            toFirestore: (story, _) => story.toMap(),
          );

      final documentReference = await ref.add(story);
      await _localCache.saveStory(
        id: documentReference.id,
        uploadTime: story.uploadTime.toIso8601String(),
      );
    } catch (e) {
      throw ApiErrorResponse(message: e.toString());
    }
  }

  @override
  Stream<List<Story>> getStories() {
    return _firestoreInstance.collection(_storiesCollection).snapshots().map(
      (snapshot) {
        final stories = List<Story>.from(
          snapshot.docs.map((document) {
            return Story.fromMap(
              document.data(),
              document.id,
            );
          }),
        );
        if (stories.isEmpty) {
          _localCache.clearSavedStories();
        } else {
          runStoryDeletionJob(stories);
        }

        stories.sort(((a, b) => b.uploadTime.compareTo(a.uploadTime)));

        return stories;
      },
    );
  }

  @override
  Future<AppUser?> getUser(String userId) async {
    try {
      return await _firestoreInstance
          .collection(_usersCollection)
          .where("id", isEqualTo: userId)
          .get()
          .then(
            (data) => AppUser.fromMap(
              data.docs.first.data(),
              data.docs.first.id,
            ),
          );
    } catch (e) {
      _logger.log(e);
      return null;
    }
  }

  @override
  Future<void> updateUserPublicKey({
    required String documentReferenceId,
    required String publicKey,
  }) async {
    try {
      await _firestoreInstance
          .collection(_usersCollection)
          .doc(documentReferenceId)
          .update(
        {"publicKey": publicKey},
      ).onError(
        (error, stackTrace) => _logger.log(error),
      );
    } catch (e) {
      _logger.log(e);
    }
  }

  @override
  Future<void> deleteStory(String imageUrl) async {
    try {
      final ref = _firestoreInstance
          .collection(_storiesCollection)
          .where("imageUrl", isEqualTo: imageUrl);

      final documentId = await ref.get().then((value) => value.docs.first.id);

      await _firestoreInstance
          .collection(_storiesCollection)
          .doc(documentId)
          .delete();

      await _imageService.deleteImage(imageUrl);
    } catch (e) {
      _logger.log(e);
      throw const ApiErrorResponse(message: "Unable to delete story");
    }
  }

  @override
  Future<File?> downloadImage(String imageUrl) async {
    return await _imageService.downloadImage(imageUrl);
  }

  @override
  Stream<List<AppUser>> getUsers() {
    return _firestoreInstance.collection(_usersCollection).snapshots().map(
          (snapshot) => List<AppUser>.from(
            snapshot.docs.map(
              (document) => AppUser.fromMap(
                document.data(),
              ),
            ),
          ),
        );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
