import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:steganograph/steganograph.dart';
import 'package:storiez/data/config/api_service.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ApiServiceImpl implements ApiService {
  late LocalCache _localCache;
  late final FirebaseAuth _authInstance = FirebaseAuth.instance;
  late final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  late final FirebaseStorage _storageInstance = FirebaseStorage.instance;

  static const _usersCollection = "users";
  static const _storiesCollection = "stories";

  ApiServiceImpl({required LocalCache localCache}) {
    _localCache = localCache;
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

      _localCache.saveUserId(user.uid);
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
      AppLogger.log(e);
      AppLogger.log(trace);
      const ApiErrorResponse(message: "Login failed");
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const ApiErrorResponse(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        const ApiErrorResponse(
          message: 'An account already exists for that email. Log in instead.',
        );
      } else {
        ApiErrorResponse(message: e.message ?? "Signup failed");
      }
    } catch (e, trace) {
      AppLogger.log(e);
      AppLogger.log(trace);
      const ApiErrorResponse(message: "Signup failed");
    }
  }

  @override
  Future<void> storyDeletionJob() async {
    try {
      final now = DateTime.now();

      final ref = _firestoreInstance
          .collection(_storiesCollection)
          .withConverter<Story>(
            fromFirestore: (snapshot, _) => Story.fromMap(
              snapshot.data()!,
            ),
            toFirestore: (story, _) => story.toMap(),
          );

      final savedStories = await _localCache.getSavedStories();

      for (var story in savedStories) {
        final date = DateTime.parse(story["uploadTime"]!);

        if (now
            .subtract(const Duration(
              hours: 23,
              minutes: 58,
            ))
            .isBefore(date)) {
          await ref
              .doc(story["id"]!)
              .delete()
              .onError((error, stackTrace) => null);
        }
      }
    } catch (e) {
      AppLogger.log(e);
    }
  }

  @override
  Future<String> uploadImage(File image) async {
    try {
      var uuid = const Uuid().v1();
      final ref = _storageInstance.ref('images/$uuid.png');
      final upload = ref.putFile(image);

      return await (await upload).ref.getDownloadURL();
    } catch (e) {
      AppLogger.log(e);
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
      _localCache.saveStory(
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
          (snapshot) => List<Story>.from(
            snapshot.docs.map(
              (document) => Story.fromMap(
                document.data(),
              ),
            ),
          ),
        );
  }
}