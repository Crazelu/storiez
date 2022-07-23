import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';

final homeViewModelProvider = ChangeNotifierProvider((_) => HomeViewModel());

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    getUser();
    subscribeToStoriesStream();
  }

  List<Story> _stories = [];
  List<Story> get stories => _stories;

  StreamSubscription<List<Story>>? _stream;

  AppUser? _user;
  AppUser? get user {
    if (_user == null) getUser();
    return _user;
  }

  Future<void> getUser() async {
    try {
      _user = await storiezService.getUser(await localCache.getUserId());
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  void subscribeToStoriesStream() {
    try {
      toggleLoading(true);
      _stream = storiezService.getStories().listen(
        (stories) {
          _stories = stories;
          toggleLoading(false);
        },
        onDone: () {
          toggleLoading(false);
        },
        onError: (err) {
          toggleLoading(false);
        },
      );
    } catch (e) {
      toggleLoading(false);
      handleError(e);
    }
  }

  void _cancelStream() {
    _stream?.cancel();
    _stream = null;
  }

  void logout() {
    localCache.persistLoginStatus(false);
    _user = null;
    _cancelStream();
    navigationHandler.pushReplacementNamed(Routes.loginViewRoute);
  }

  @override
  void dispose() {
    _cancelStream();
    super.dispose();
  }
}
