import 'package:flutter/material.dart';

class AppColors {
  static const darkGreen = Color(0xFF1a3d17);
  static const mediumGreen = Color(0xFF2d5a27);
  static const lightGreen = Color(0xFF4a7c3f);
  static const softGreen = Color(0xFF7a9e7e);
  static const bgGreen = Color(0xFFf5f7f0);
  static const cardGreen = Color(0xFFf0f7ed);
  static const borderGreen = Color(0xFFe8f0e5);
}

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mediumGreen),
  scaffoldBackgroundColor: AppColors.bgGreen,
  fontFamily: 'sans-serif',
);