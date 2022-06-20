import 'dart:io';

abstract class ImageUploadService {
  Future<bool> uploadImage(File image);
}
