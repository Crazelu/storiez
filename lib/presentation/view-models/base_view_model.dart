import 'package:flutter/material.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/handlers/handlers.dart';
import 'package:storiez/utils/locator.dart';
import 'package:storiez/utils/utils.dart';

///Base view model with shared dependencies injected.
///All view models must extends this class.
class BaseViewModel extends ChangeNotifier {
  late NavigationHandler navigationHandler;
  late DialogHandler dialogHandler;
  late LocalCache localCache;

  BaseViewModel({
    NavigationHandler? navigationHandler,
    DialogHandler? dialogHandler,
    LocalCache? localCache,
  }) {
    this.navigationHandler = navigationHandler ?? locator();
    this.dialogHandler = dialogHandler ?? locator();
    this.localCache = localCache ?? locator();
  }
  bool _loading = false;
  bool get loading => _loading;

  void toggleLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void log(Object? e) {
    AppLogger.log(e);
  }
}
