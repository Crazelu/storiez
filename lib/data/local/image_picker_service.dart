import 'package:photo_manager/photo_manager.dart';
import 'package:storiez/domain/models/api/error/api_error_response.dart';
import 'package:storiez/domain/models/asset_image.dart';
import 'package:storiez/utils/utils.dart';

abstract class ImagePickerService {
  Future<List<AssetImage>> getImages();
  Future<bool> hasPermission();
}

class ImagePickerServiceImpl implements ImagePickerService {
  late final _logger = Logger(ImagePickerServiceImpl);
  @override
  Future<List<AssetImage>> getImages() async {
    try {
      if (await hasPermission()) {
        final albums = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
        );
        final recentAlbum = albums.first;

        final images = await recentAlbum.getAssetListRange(
          start: 0,
          end: 1000000, // end at a very big index (to get all the assets)
        );

        return List<AssetImage>.from(
          images.map(
            (e) => AssetImage(
              file: e.file,
              thumbData: e.thumbnailData,
            ),
          ),
        );
      } else {
        throw const ApiErrorResponse(
          message: "Photo library permission denied",
        );
      }
    } catch (e) {
      _logger.log(e);
    }
    return [];
  }

  @override
  Future<bool> hasPermission() async {
    final state = await PhotoManager.requestPermissionExtend();
    if (state == PermissionState.authorized ||
        state == PermissionState.limited) {
      return true;
    }

    await PhotoManager.openSetting();
    return false;
  }
}
