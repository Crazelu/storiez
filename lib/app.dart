import 'package:flutter/material.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storiez/handlers/handlers.dart';
import 'package:storiez/presentation/dialogs/dialog_generator.dart';
import 'package:storiez/presentation/routes/route_generator.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/utils/locator.dart';
import 'package:storiez/presentation/themes/light_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogManager(
      dialogKey: locator<DialogHandler>().dialogKey,
      navigatorKey: locator<NavigationHandler>().navigatorKey,
      onGenerateDialog: DialogGenerator.onGenerateDialog,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Storiez',
        theme: lightTheme.copyWith(
          textTheme: GoogleFonts.notoSansTextTheme(lightTheme.textTheme),
        ),
        scaffoldMessengerKey: locator<SnackbarHandler>().key,
        navigatorKey: locator<NavigationHandler>().navigatorKey,
        onGenerateRoute: RouteGenerator.onGenerateRoute,
        initialRoute: Routes.splashScreenViewRoute,
        builder: (_, child) => ProviderScope(child: child!),
      ),
    );
  }
}
