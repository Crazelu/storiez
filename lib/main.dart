import 'package:flutter/material.dart';
import 'package:storiez/app.dart';
import 'package:storiez/utils/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const App());
}
