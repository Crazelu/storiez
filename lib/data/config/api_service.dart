import 'dart:io';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';

abstract class ApiService {
  ///Uploads an image
  Future<String> uploadImage(File image);

  ///Registers a user
  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  });

  ///Logs a user in
  Future<void> login({
    required String email,
    required String password,
  });

  ///Uploads a story
  Future<void> uploadStory(Story story);

  ///Job that periodically runs to delete stories older than 24 hours
  Future<void> storyDeletionJob();

  ///Returns available stories
  Stream<List<Story>> getStories();

  ///Gets a user by [userId]
  Future<AppUser?> getUser(String userId);

  ///Updates a user's public key
  Future<void> updateUserPublicKey({
    required String documentReferenceId,
    required String publicKey,
  });

  ///Deletes story with [imageUrl]
  Future<void> deleteStory(String imageUrl);

  ///Downloads image from [imageUrl]
  Future<File?> downloadImage(String imageUrl);
}
