import 'package:get_it/get_it.dart';
import '../handlers/handlers.dart';

GetIt locator = GetIt.instance;

///Registers dependencies
Future<void> setupLocator({String baseApi = ''}) async {
  locator
      .registerLazySingleton<NavigationHandler>(() => NavigationHandlerImpl());
  locator.registerLazySingleton<DialogHandler>(() => DialogHandlerImpl());
}
