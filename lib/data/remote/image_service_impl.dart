import 'dart:io';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storiez/data/remote/image_service.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ImageServiceImpl implements ImageService {
  late Cloudinary _cloudinaryInstance;

  ImageServiceImpl({
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
  Future<String> uploadImage(File image) async {
    final imageName = const Uuid().v1();
    final response = await _cloudinaryInstance.uploadResource(
      CloudinaryUploadResource(
        filePath: image.path,
        fileBytes: image.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: "storiez-images",
        fileName: imageName,
        progressCallback: (count, total) {
          AppLogger.log(
            'Uploading image from file with progress: $count/$total',
          );
        },
      ),
    );

    if (!response.isSuccessful) {
      throw ApiErrorResponse(message: response.error ?? "Image upload failed");
    }

    return response.secureUrl!;
  }

  @override
  Future<void> deleteImage(String url) async {
    try {
      await _cloudinaryInstance.deleteResource(
        url: url,
        resourceType: CloudinaryResourceType.image,
        invalidate: true,
      );
    } catch (e) {
      AppLogger.log(e);
    }
  }

  @override
  Future<File?> downloadImage(String imageUrl) async {
    try {
      final cachedFilePath = _imageCache[imageUrl];

      if (cachedFilePath != null) {
        AppLogger.log("Retrieved from cache");
        return File(cachedFilePath);
      }

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
      _imageCache[imageUrl] = file.path;
      return file;
    } catch (e) {
      AppLogger.log(e);
      throw const ApiErrorResponse(message: "Image download failed");
    }
  }

  late final Map<String, String> _imageCache = {};

  @override
  Map<String, String> get imageCache => _imageCache;
}
