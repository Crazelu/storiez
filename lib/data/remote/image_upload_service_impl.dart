import 'dart:io';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:storiez/data/remote/image_upload_service.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';

class ImageUploadServiceImpl implements ImageUploadService {
  late Cloudinary _cloudinaryInstance;

  ImageUploadServiceImpl({
    required String apiKey,
    required String apiSecret,
    required String cloudName,
  }) {
    _cloudinaryInstance = Cloudinary.full(
      apiKey: apiKey,
      apiSecret: apiSecret,
      cloudName: cloudName,
    );
  }

  @override
  Future<bool> uploadImage(File image) async {
    final response = await _cloudinaryInstance.uploadResource(
      CloudinaryUploadResource(
        filePath: image.path,
        fileBytes: image.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: "storiez-images",
        fileName: DateTime.now().toIso8601String(),
        progressCallback: (count, total) {
          print('Uploading image from file with progress: $count/$total');
        },
      ),
    );

    if (!response.isSuccessful) {
      throw ApiErrorResponse(message: response.error ?? "Image upload failed");
    }

    return response.isSuccessful;
  }
}
