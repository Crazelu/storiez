import 'package:flutter/material.dart';
import 'package:storiez/data/config/api_service.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/handlers/handlers.dart';
import 'package:storiez/presentation/app_toast.dart';
import 'package:storiez/utils/utils.dart';

///Base view model with shared dependencies injected.
///All view models must extends this class.
class BaseViewModel extends ChangeNotifier {
  late NavigationHandler navigationHandler;
  late DialogHandler dialogHandler;
  late LocalCache localCache;
  late ApiService apiService;

  BaseViewModel({
    NavigationHandler? navigationHandler,
    DialogHandler? dialogHandler,
    LocalCache? localCache,
    ApiService? apiService,
  }) {
    this.navigationHandler = navigationHandler ?? locator();
    this.dialogHandler = dialogHandler ?? locator();
    this.localCache = localCache ?? locator();
    this.apiService = apiService ?? locator();
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

  void handleError(Object e) {
    if (e is ApiErrorResponse) {
      AppToast.instance.error(e.message);
    }
    log(e);
  }
}
