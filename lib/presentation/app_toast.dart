import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:storiez/handlers/navigation_handler.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/shared/custom_text.dart';
import 'package:storiez/utils/locator.dart';

enum FeedbackType { error, info }

class AppToast {
  AppToast._instance();
  static AppToast instance = AppToast._instance();

  void showSnackBar({
    String? message,
    FeedbackType feedbackType = FeedbackType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar(
      messageText: CustomText.regular(
        text: message ?? 'Error',
        color: Palette.primaryColorLight,
        fontWeight: FontWeight.w500,
      ),
      duration: duration,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 36,
      ),
      borderRadius: BorderRadius.circular(4),
      backgroundColor: feedbackType == FeedbackType.error
          ? Palette.faintRed
          : Palette.lightGreen,
    ).show(locator<NavigationHandler>().navigatorKey.currentContext!);
  }

  error(String message) {
    showSnackBar(feedbackType: FeedbackType.error, message: message);
  }
}
