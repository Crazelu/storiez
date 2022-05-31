import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';

final splashViewModelProvider = ChangeNotifierProvider((_ref) {
  return SplashViewModel();
});

class SplashViewModel extends BaseViewModel {
  SplashViewModel() {
    checkLoginStatus();
  }
  Future<void> checkLoginStatus() async {
    try {
      final userId = await localCache.getUserId();

      await Future.delayed(const Duration(milliseconds: 1500));

      if (userId.isEmpty) {
        navigationHandler.pushReplacementNamed(Routes.loginViewRoute);
      } else {
        navigationHandler.pushReplacementNamed(Routes.homeViewRoute);
      }
    } catch (e) {
      log(e);
      await Future.delayed(const Duration(milliseconds: 800));
      navigationHandler.pushReplacementNamed(Routes.loginViewRoute);
    }
  }
}
