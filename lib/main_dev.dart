import 'package:flutter/material.dart';
import 'package:throtty/app.dart';
import 'package:throtty/utils/utils.dart';

void main() {
  AppLogger.configure(showLogs: true);
  setupLocator();
  runApp(const App());
}
