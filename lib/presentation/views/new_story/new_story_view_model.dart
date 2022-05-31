import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';

final newStoryViewModelProvider = ChangeNotifierProvider((_) {
  return NewStoryViewModel();
});

class NewStoryViewModel extends BaseViewModel {
  Future<void> uploadStory({
    required File image,
    String caption = "",
  }) async {
    try {
      final imageUrl = await apiService.uploadImage(image);
      final poster = await apiService.getUser(await localCache.getUserId());

      navigationHandler.pop();
      navigationHandler.pop();

      await apiService.uploadStory(
        Story(
          imageUrl: imageUrl,
          poster: poster!,
          uploadTime: DateTime.now(),
          caption: caption,
        ),
      );

      showSnackBar("Story uploaded!");
    } catch (e) {
      handleError(e);
    }
  }
}
