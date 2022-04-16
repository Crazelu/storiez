import 'package:flutter/material.dart';
import 'package:storiez/app.dart';
import 'package:storiez/utils/utils.dart';

void main() {
  AppLogger.configure(showLogs: true);
  setupLocator();
  runApp(const App());
}
