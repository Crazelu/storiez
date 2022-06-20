import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steganograph/steganograph.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';

final newStoryViewModelProvider = ChangeNotifierProvider((_) {
  return NewStoryViewModel();
});

class NewStoryViewModel extends BaseViewModel {
  NewStoryViewModel() {
    getUser();
  }

  AppUser? _user;

  Future<void> getUser() async {
    try {
      _user = await apiService.getUser(await localCache.getUserId());
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

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

      final imageUrl = await apiService.uploadImage(encodedImage!);
      log("Image uploaded");

      if (_user == null) {
        await getUser();
      }

      try {
        encodedImage.delete();
      } catch (e) {
        log(e);
      }

      await apiService.uploadStory(
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
      if (recipientPublicKey == null || secretMessage == null) {
        return await Steganograph.encode(
          image: image,
          message: "",
        );
      }

      return await Steganograph.encode(
        image: image,
        message: secretMessage,
        unencryptedPrefix: recipientId,
        encryptionKey: recipientPublicKey,
        encryptionType: EncryptionType.asymmetric,
      );
    } on SteganographFileException {
      throw const ApiErrorResponse(
        message: "Image format is not supported. Upload a JPG or PNG image.",
      );
    } catch (e) {
      handleError(e);
    }
    return null;
  }
}
