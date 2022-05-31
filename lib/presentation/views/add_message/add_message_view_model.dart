import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';

final addMessageViewModelProvider = ChangeNotifierProvider(
  (_) => AddMessageViewModel(),
);

class AddMessageViewModel extends BaseViewModel {
  AddMessageViewModel() {
    getUsers();
  }
  List<AppUser> _users = [];
  List<AppUser> get users => _users;

  StreamSubscription<List<AppUser>>? _stream;

  void getUsers() {
    try {
      toggleLoading(true);
      _stream = apiService.getUsers().listen(
        (users) {
          _users = users;
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

  @override
  void dispose() {
    _stream?.cancel();
    _stream = null;
    super.dispose();
  }
}
