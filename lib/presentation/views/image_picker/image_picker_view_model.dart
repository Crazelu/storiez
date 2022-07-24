import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/domain/models/asset_image.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';
import 'package:storiez/utils/locator.dart';

final imagePickerViewModelProvider = ChangeNotifierProvider.autoDispose((_) {
  return ImagePickerViewModel();
});

class ImagePickerViewModel extends BaseViewModel {
  late ImagePickerService _imagePicker;

  ImagePickerViewModel({ImagePickerService? imagePicker}) {
    _imagePicker = imagePicker ?? locator();
  }

  List<AssetImage> _images = [];
  List<AssetImage> get images => _images;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  int _page = 1;
  bool _shouldFetch = true;
  static const _itemsPerPage = 50;

  Future<void> getImages() async {
    try {
      if (loading || !_shouldFetch) return;

      toggleLoading(true);

      final fetchedImages = await _imagePicker.getImages(
        page: _page,
        itemsPerPage: _itemsPerPage,
      );

      if (fetchedImages.length < _itemsPerPage) {
        _shouldFetch = false;
      } else {
        _page++;
      }
      _images += fetchedImages;

      toggleLoading(false);
    } catch (e) {
      toggleLoading(false);
      handleError(e);
    }
  }

  void setSelectedImage(File image) {
    _selectedImage = image;
    notifyListeners();
  }
}
