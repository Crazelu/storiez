import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:throtty/data/local/__local.dart';
import 'package:throtty/handlers/handlers.dart';

GetIt locator = GetIt.instance;

///Registers dependencies
Future<void> setupLocator({String baseApi = ''}) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton(sharedPreferences);

  //Local storage
  locator.registerLazySingleton<SecureStorage>(
    () => SecureStorageImpl(),
  );

  locator.registerLazySingleton<LocalCache>(
    () => LocalCacheImpl(
      sharedPreferences: locator(),
      storage: locator(),
    ),
  );

  //Handlers
  locator
      .registerLazySingleton<NavigationHandler>(() => NavigationHandlerImpl());
  locator.registerLazySingleton<DialogHandler>(() => DialogHandlerImpl());
}
