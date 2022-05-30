import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:storiez/app.dart';
import 'package:storiez/utils/locator.dart';
import 'package:storiez/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  runApp(const App());
}
