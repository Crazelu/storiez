import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steganograph/steganograph.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/presentation/stores/user_store.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';
import 'package:storiez/utils/locator.dart';

final newStoryViewModelProvider = ChangeNotifierProvider((_) {
  return NewStoryViewModel();
});

class NewStoryViewModel extends BaseViewModel {
  late final UserStore _userStore = locator();
  NewStoryViewModel() {
    _addListeners();
    _userStore.getUser();
  }

  void _addListeners() {
    _user = _userStore.user.value;
    _userStore.user.addListener(() {
      _user = _userStore.user.value;
    });
  }

  AppUser? _user;

  Future<void> uploadStory({
    required File image,
    String? recipientId,
    String caption = "",
    String? recipientPublicKey,
    String? secretMessage,
  }) async {
    File? encodedImage;
    try {
      if (loading) {
        showErrorSnackBar("An upload is in progress");
        return;
      }
      toggleLoading(true);

      log("Start story upload");
      navigationHandler.pop();
      navigationHandler.pop();
      showSnackBar("Uploading story...");

      encodedImage = await _writeSecretMessageToImage(
        image: image,
        recipientId: recipientId,
        recipientPublicKey: recipientPublicKey,
        secretMessage: secretMessage,
      );

      log(encodedImage);

      if (_user == null) {
        await _userStore.getUser();
      }

      final imageUrl = await storiezService.uploadImage(encodedImage!);
      log("Image uploaded");

      try {
        encodedImage.delete();
      } catch (e) {
        log(e);
      }

      await storiezService.uploadStory(
        Story(
          imageUrl: imageUrl,
          poster: _user!,
          uploadTime: DateTime.now(),
          caption: caption,
        ),
      );
      toggleLoading(false);
      showSnackBar("Story uploaded!");
    } catch (e) {
      toggleLoading(false);
      handleError(e);
      try {
        encodedImage?.delete();
      } catch (e) {
        log(e);
      }
    }
  }

  Future<File?> _writeSecretMessageToImage({
    required File image,
    String? recipientId,
    String? recipientPublicKey,
    String? secretMessage,
  }) async {
    try {
      final receivePort = ReceivePort();
      final args = <String, dynamic>{
        "sendPort": receivePort.sendPort,
        "recipientPublicKey": recipientPublicKey,
        "secretMessage": secretMessage,
        "recipientId": recipientId,
        "imagePath": image.path,
      };
      await Isolate.spawn(_encodeImage, args);
      final result = await receivePort.first as TransferableTypedData;
      final bytes = result.materialize().asInt8List();

      if (bytes.isEmpty) {
        throw const ApiErrorResponse(
          message: "Image format is not supported. Upload a JPG or PNG image.",
        );
      }
      var file = File(image.path);
      file = await file.writeAsBytes(bytes);
      return file;
    } catch (e, trace) {
      handleError(e);
      log(trace);
      return null;
    }
  }

  static Future<void> _encodeImage(Map<String, dynamic> args) async {
    String recipientPublicKey = args['recipientPublicKey'] ?? "";
    String secretMessage = args['secretMessage'] ?? "";
    String recipientId = args['recipientId'] ?? "";
    String imagePath = args['imagePath'] ?? "";
    SendPort sendPort = args['sendPort'];

    try {
      File? result;
      if (recipientPublicKey.isEmpty || secretMessage.isEmpty) {
        result = await Steganograph.encode(
          image: File(imagePath),
          message: "",
        );
      } else {
        result = await Steganograph.encode(
          image: File(imagePath),
          message: secretMessage,
          unencryptedPrefix: recipientId,
          encryptionKey: recipientPublicKey,
          encryptionType: EncryptionType.asymmetric,
        );
      }

      final encodedImageBytes = result?.readAsBytesSync();

      Isolate.exit(
        sendPort,
        TransferableTypedData.fromList([
          encodedImageBytes ?? Uint8List.fromList([]),
        ]),
      );
    } catch (e) {
      Isolate.exit(
        sendPort,
        TransferableTypedData.fromList([
          Uint8List.fromList([]),
        ]),
      );
    }
  }
}
