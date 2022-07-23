import 'package:steganograph/steganograph.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';

class StoryViewModel extends BaseViewModel {
  StoryViewModel() {
    getUser();
  }

  AppUser? _user;
  AppUser? get user => _user;
  String _secretMessage = "";

  Future<String?> _downloadImageAndDecode(String imageUrl) async {
    try {
      final imageFile = await storiezService.downloadImage(imageUrl);

      final privateKey = await localCache.getPrivateKey();
      final currentUserId = await localCache.getUserId();

      final message = await Steganograph.decode(
        image: imageFile!,
        encryptionKey: privateKey,
        unencryptedPrefix: currentUserId,
        encryptionType: EncryptionType.asymmetric,
      );

      return message;
    } catch (e, trace) {
      log(trace);
      log(e);
    }
    return null;
  }

  Future<bool> hasSecret(Story story) async {
    try {
      final message = await _downloadImageAndDecode(story.imageUrl);

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

  Future<void> getUser() async {
    try {
      _user = await storiezService.getUser(await localCache.getUserId());
      notifyListeners();
    } catch (e) {
      handleError(e);
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
