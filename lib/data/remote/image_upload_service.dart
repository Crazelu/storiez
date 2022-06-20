import 'dart:io';

abstract class ImageUploadService {
  Future<String> uploadImage(File image);

  Future<void> deleteImage(String url);
}
