import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';

final loginViewModelProvider = ChangeNotifierProvider((_) {
  return LoginViewModel();
});

class LoginViewModel extends BaseViewModel {
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      toggleLoading(true);
      await storiezService.login(email: email, password: password);
      toggleLoading(false);
      navigationHandler.pushReplacementNamed(Routes.homeViewRoute);
    } catch (e) {
      toggleLoading(false);
      handleError(e);
    }
  }
}
