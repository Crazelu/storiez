import 'dart:convert';
import 'package:steganograph/steganograph.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';
import 'package:storiez/utils/utils.dart';

class StoryViewModel extends BaseViewModel {
  StoryViewModel() {
    getUser();
  }

  AppUser? _user;
  AppUser? get user => _user;

  Future<String?> _downloadImageAndDecode(String imageUrl) async {
    try {
      final imageFile = await apiService.downloadImage(imageUrl);

      AppLogger.log("Starting steganography decoding");
      final message = await Steganograph.decode(
        image: imageFile!,
      );

      // log("MESSAGE: $message");
      return message;
    } catch (e, trace) {
      log(trace);
      log(e);
    }
    return null;
  }

  bool? _hasSecret;

  Future<bool> hasSecret(Story story) async {
    if (_hasSecret != null) {
      return _hasSecret!;
    }
    try {
      final message = await _downloadImageAndDecode(story.imageUrl);

      log(message);
      if (message == null || message.isEmpty) {
        _hasSecret = false;
        return false;
      }

      final secret = jsonDecode(message) as Map<String, dynamic>;

      log(secret);

      final currentUserId = await localCache.getUserId();
      log(currentUserId);

      for (var key in secret.keys) {
        if (key == currentUserId) {
          _hasSecret = true;
          return true;
        }
      }
    } catch (e) {
      log(e);
    }
    _hasSecret = false;
    return false;
  }

  Future<void> getUser() async {
    try {
      _user = await apiService.getUser(await localCache.getUserId());
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> deleteStory(Story story) async {
    try {
      if (loading) return;
      toggleLoading(true);
      await apiService.deleteStory(story.imageUrl);
      toggleLoading(false);
      showSnackBar("Story deleted");
    } catch (e) {
      toggleLoading(false);
      handleError(e);
    }
  }
}
