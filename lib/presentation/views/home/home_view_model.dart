import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/stores/user_store.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';
import 'package:storiez/utils/locator.dart';

final homeViewModelProvider = ChangeNotifierProvider((_) => HomeViewModel());

class HomeViewModel extends BaseViewModel {
  late final UserStore _userStore = locator();

  HomeViewModel() {
    _addListeners();
    _userStore.getUser();
    subscribeToStoriesStream();
  }

  void _addListeners() {
    _user = _userStore.user.value;
    notifyListeners();
    _userStore.user.addListener(() {
      _user = _userStore.user.value;
      notifyListeners();
    });
  }

  List<Story> _stories = [];
  List<Story> get stories => _stories;

  StreamSubscription<List<Story>>? _stream;

  AppUser? _user;
  AppUser? get user {
    if (_user == null) _userStore.getUser();
    return _user;
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
    _user = null;
    _cancelStream();
    super.dispose();
  }
}
