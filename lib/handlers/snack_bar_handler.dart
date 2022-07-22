import 'package:flutter/material.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/shared/custom_text.dart';

abstract class SnackbarHandler {
  GlobalKey<ScaffoldMessengerState> get key;
  void showErrorSnackbar(String message);
  void showSnackbar(String message);
}

class SnackbarHandlerImpl implements SnackbarHandler {
  late final GlobalKey<ScaffoldMessengerState> _key;

  SnackbarHandlerImpl({GlobalKey<ScaffoldMessengerState>? state}) {
    _key = state ?? GlobalKey<ScaffoldMessengerState>();
  }

  @override
  void showErrorSnackbar(String message) {
    _key.currentState!.hideCurrentSnackBar();
    _key.currentState!.showSnackBar(
      SnackBar(
        backgroundColor: Palette.faintRed,
        content: CustomText.regular(
          text: message,
          color: Palette.primaryColorLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void showSnackbar(String message) {
    _key.currentState!.hideCurrentSnackBar();
    _key.currentState!.showSnackBar(
      SnackBar(
        backgroundColor: Palette.lightGreen,
        content: CustomText.regular(
          text: message,
          color: Palette.primaryColorLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  GlobalKey<ScaffoldMessengerState> get key => _key;
}
