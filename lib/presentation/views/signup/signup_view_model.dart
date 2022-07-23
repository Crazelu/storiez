import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';

final signupViewModelProvider = ChangeNotifierProvider((_) {
  return SignupViewModel();
});

class SignupViewModel extends BaseViewModel {
  Future<void> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      toggleLoading(true);
      await storiezService.signUp(
        email: email,
        password: password,
        username: username,
      );
      toggleLoading(false);
      navigationHandler.pushReplacementNamed(Routes.homeViewRoute);
    } catch (e) {
      toggleLoading(false);
      handleError(e);
    }
  }
}
