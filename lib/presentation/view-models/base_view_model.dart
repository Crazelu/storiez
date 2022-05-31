import 'package:flutter/material.dart';
import 'package:storiez/data/config/api_service.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/handlers/handlers.dart';
import 'package:storiez/utils/utils.dart';

///Base view model with shared dependencies injected.
///All view models must extends this class.
class BaseViewModel extends ChangeNotifier {
  late NavigationHandler navigationHandler;
  late DialogHandler dialogHandler;
  late SnackbarHandler snackbarHandler;
  late LocalCache localCache;
  late ApiService apiService;

  BaseViewModel({
    NavigationHandler? navigationHandler,
    DialogHandler? dialogHandler,
    LocalCache? localCache,
    ApiService? apiService,
    SnackbarHandler? snackbarHandler,
  }) {
    this.navigationHandler = navigationHandler ?? locator();
    this.dialogHandler = dialogHandler ?? locator();
    this.localCache = localCache ?? locator();
    this.apiService = apiService ?? locator();
    this.snackbarHandler = snackbarHandler ?? locator();
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
