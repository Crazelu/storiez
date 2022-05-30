import 'dart:io';
import 'package:storiez/domain/models/story.dart';

abstract class ApiService {
  Future<String> uploadImage(File image);

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  });

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> uploadStory(Story story);

  Future<void> storyDeletionJob();

  Stream<List<Story>> getStories();
}
