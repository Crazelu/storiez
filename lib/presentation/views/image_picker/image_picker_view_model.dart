import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/data/local/__local.dart';
import 'package:storiez/domain/models/asset_image.dart';
import 'package:storiez/presentation/view-models/base_view_model.dart';
import 'package:storiez/utils/locator.dart';

final imagePickerViewModelProvider = ChangeNotifierProvider((_) {
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

  Future<void> getImages() async {
    try {
      if (_images.isNotEmpty) return;

      _images = await _imagePicker.getImages();
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  void setSelectedImage(File image) {
    _selectedImage = image;
    notifyListeners();
  }
}
