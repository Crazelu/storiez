import 'dart:io';

abstract class ImageService {
  ///Uploads an image and returns the image url
  Future<String> uploadImage(File image);

  ///Deletes image with [url]
  Future<void> deleteImage(String url);

  ///Downloads image from [imageUrl] to file system
  Future<File?> downloadImage(
    String imageUrl, [
    String? imageDirectoryPath,
  ]);

  ///Image Cache
  Map<String, String> get imageCache;
}
