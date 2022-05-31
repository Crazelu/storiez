import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:steganograph/steganograph.dart';
import 'package:storiez/data/config/api_service.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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

      final appUser = await getUser(user.uid);

      if (appUser != null) {
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
      }
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
      AppLogger.log("Start image upload");
      final uuid = const Uuid().v1();
      final ref = _storageInstance.ref('images/$uuid.png');
      await ref.putFile(image);

      AppLogger.log("Getting download link");

      return await ref.getDownloadURL();
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
      AppLogger.log(e);
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
        (error, stackTrace) => AppLogger.log(error),
      );
    } catch (e) {
      AppLogger.log(e);
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
    } catch (e) {
      AppLogger.log(e);
      throw const ApiErrorResponse(message: "Unable to delete story");
    }
  }

  @override
  Future<File?> downloadImage(String imageUrl) async {
    try {
      AppLogger.log("Starting image download");
      final response = await http.get(Uri.parse(imageUrl));
      final imageBytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final uuid = const Uuid().v1();
      final imageDirPath = dir.path + "/images";
      final downloadedImageFilePath = imageDirPath + "/$uuid.png";
      await Directory(imageDirPath).create(recursive: true);
      final file = File(downloadedImageFilePath);
      await file.writeAsBytes(imageBytes);
      AppLogger.log("Image downloaded to " + file.path);
      return file;
    } catch (e) {
      AppLogger.log(e);
      throw const ApiErrorResponse(message: "Image download failed");
    }
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
}
