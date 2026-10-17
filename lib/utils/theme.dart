import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: AppColors.primarySwatch,
    scaffoldBackgroundColor: AppColors.primaryPurple,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}