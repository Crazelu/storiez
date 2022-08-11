import 'package:flutter/material.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/data/remote/storiez_service.dart';
import 'package:storiez/domain/models/api/api_error_response.dart';
import 'package:storiez/handlers/handlers.dart';
import 'package:storiez/utils/utils.dart';

///Base view model with shared dependencies injected.
///All view models must extends this class.
class BaseViewModel extends ChangeNotifier {
  late final _logger = Logger(runtimeType);
  late NavigationHandler navigationHandler;
  late SnackbarHandler snackbarHandler;
  late LocalCache localCache;
  late StoriezService storiezService;

  BaseViewModel({
    NavigationHandler? navigationHandler,
    LocalCache? localCache,
    StoriezService? storiezService,
    SnackbarHandler? snackbarHandler,
  }) {
    this.navigationHandler = navigationHandler ?? locator();
    this.localCache = localCache ?? locator();
    this.storiezService = storiezService ?? locator();
    this.snackbarHandler = snackbarHandler ?? locator();
  }
  bool _loading = false;
  bool get loading => _loading;

  void toggleLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void log(Object? e) {
    _logger.log(e);
  }

  void showSnackBar(String message) {
    snackbarHandler.showSnackbar(message);
  }

  void showErrorSnackBar(String message) {
    snackbarHandler.showErrorSnackbar(message);
  }

  void handleError(Object e) {
    if (e is ApiErrorResponse) {
      showErrorSnackBar(e.message);
    }
    log(e);
  }
}
