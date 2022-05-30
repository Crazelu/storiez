import 'package:flutter/material.dart';
import 'package:storiez/app.dart';
import 'package:storiez/firebase_options.dart';
import 'package:storiez/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppLogger.configure(showLogs: true);
  setupLocator();
  runApp(const App());
}
