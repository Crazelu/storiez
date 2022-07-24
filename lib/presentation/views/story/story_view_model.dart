import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'package:steganograph/steganograph.dart';
import 'package:storiez/data/remote/image_service_impl.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';
import 'package:storiez/presentation/views/story/secret_cache.dart';

///Downloads image from internet and decodes image to extract secret message
Future<void> _downloadImageAndDecode(
  Map<String, dynamic> args,
) async {
  SendPort sendPort = args["sendPort"];
  try {
    final imageService = ImageServiceImpl(
      apiKey: const String.fromEnvironment('CLOUDINARY_API_KEY'),
      apiSecret: const String.fromEnvironment('CLOUDINARY_API_SECRET'),
      cloudName: const String.fromEnvironment('CLOUDINARY_CLOUD_NAME'),
    );

    final imageFile = await imageService.downloadImage(
      args["imageUrl"],
      args["imageDirPath"],
    );

    final message = await Steganograph.decode(
      image: imageFile!,
      encryptionKey: args["privateKey"],
      unencryptedPrefix: args["currentUserId"],
      encryptionType: EncryptionType.asymmetric,
    );
    Isolate.exit(sendPort, message ?? "");
  } catch (e) {
    Isolate.exit(sendPort, "");
  }
}

class StoryViewModel extends BaseViewModel {
  String _secretMessage = "";

  /// Checks [SecretCache] for [imageUrl] and retrieve cached secret.
  /// If [imageUrl] is not in cache, an isolate is spawn to handle
  /// image download and steganograph decode of the image to extract the secret
  /// message (if any).
  Future<String?> _getSecret(String imageUrl) async {
    try {
      final secretFromCache = SecretCache.lookup(imageUrl);

      if (secretFromCache != null) return secretFromCache;

      final dir = await getApplicationDocumentsDirectory();
      final imageDirPath = dir.path + "/images";

      final receivePort = ReceivePort();
      final args = {
        "sendPort": receivePort.sendPort,
        "imageUrl": imageUrl,
        "imageDirPath": imageDirPath,
        "privateKey": await localCache.getPrivateKey(),
        "currentUserId": await localCache.getUserId(),
      };

      await Isolate.spawn(_downloadImageAndDecode, args);
      final secret = await receivePort.first as String;

      SecretCache.cacheSecret(
        imageUrl: imageUrl,
        secret: secret,
      );
      return secret;
    } catch (e) {
      log(e);
      return null;
    }
  }

  ///Checks if this story has any secret message
  Future<bool> hasSecret(Story story) async {
    try {
      final message = await _getSecret(story.imageUrl);

      if (message != null && message.isNotEmpty) {
        _secretMessage = message;
        return true;
      }
    } catch (e, trace) {
      log(trace);
      log(e);
    }

    return false;
  }

  void showSecret(Story story) {
    try {
      if (_secretMessage.isNotEmpty) {
        showSnackBar(
          "Secret message from ${story.poster.username} : $_secretMessage",
        );
      }
    } catch (e) {
      log(e);
    }
  }

  Future<void> deleteStory(Story story) async {
    try {
      if (loading) return;
      toggleLoading(true);
      await storiezService.deleteStory(story.imageUrl);
      toggleLoading(false);
      showSnackBar("Story deleted");
    } catch (e) {
      toggleLoading(false);
      handleError(e);
    }
  }
}
