import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: AppColors.primaryMaterialColor,
      scaffoldBackgroundColor: AppColors.primaryGradientStart,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}