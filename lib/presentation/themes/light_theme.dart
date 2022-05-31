import 'package:flutter/material.dart';
import 'package:storiez/presentation/resources/palette.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Palette.primaryColorLight,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Palette.primaryColor,
    foregroundColor: Palette.primaryColorLight,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Palette.primaryColorLight,
    foregroundColor: Palette.primaryColor,
  ),
);
