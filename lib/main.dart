import 'package:flutter/material.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../handlers/handlers.dart';
import '../../presentation/dialogs/dialog_generator.dart';
import '../../presentation/routes/route_generator.dart';
import '../../presentation/routes/routes.dart';
import '../../utils/locator.dart';
import '../../presentation/themes/light_theme.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 630),
      builder: () => DialogManager(
        dialogKey: locator<DialogHandler>().dialogKey,
        navigatorKey: locator<NavigationHandler>().navigatorKey,
        onGenerateDialog: DialogGenerator.onGenerateDialog,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'App',
          theme: lightTheme,
          navigatorKey: locator<NavigationHandler>().navigatorKey,
          onGenerateRoute: RouteGenerator.onGenerateRoute,
          initialRoute: Routes.splashScreenViewRoute,
        ),
      ),
    );
  }
}
