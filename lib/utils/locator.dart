import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storiez/data/config/api_service.dart';
import 'package:storiez/data/config/api_service_impl.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/data/remote/image_upload_service.dart';
import 'package:storiez/data/remote/image_upload_service_impl.dart';
import 'package:storiez/handlers/handlers.dart';

GetIt locator = GetIt.instance;

///Registers dependencies
Future<void> setupLocator() async {
  const String cloudinaryApiKey = String.fromEnvironment('CLOUDINARY_API_KEY');
  const String cloudinaryApiSecret =
      String.fromEnvironment('CLOUDINARY_API_SECRET');
  const String cloudinaryCloudName =
      String.fromEnvironment('CLOUDINARY_CLOUD_NAME');

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

  locator.registerLazySingleton<ApiService>(
    () => ApiServiceImpl(localCache: locator()),
  );

  locator.registerLazySingleton<ImagePickerService>(
    () => ImagePickerServiceImpl(),
  );

  locator.registerLazySingleton<ImageUploadService>(
    () => ImageUploadServiceImpl(
      apiKey: cloudinaryApiKey,
      apiSecret: cloudinaryApiSecret,
      cloudName: cloudinaryCloudName,
    ),
  );

  //Handlers
  locator
      .registerLazySingleton<NavigationHandler>(() => NavigationHandlerImpl());
  locator.registerLazySingleton<DialogHandler>(() => DialogHandlerImpl());
  locator.registerLazySingleton<SnackbarHandler>(() => SnackbarHandlerImpl());
}
