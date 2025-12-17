import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF667eea);
  static const Color secondaryPurple = Color(0xFF764ba2);
  static const Color accentRed = Color(0xFFff6b6b);

  static const MaterialColor primarySwatch = MaterialColor(0xFF667eea, {
    50: Color(0xFFE8EBFE),
    100: Color(0xFFC5CEFC),
    200: Color(0xFF9EAEF9),
    300: Color(0xFF778DF6),
    400: Color(0xFF5975F4),
    500: Color(0xFF667eea),
    600: Color(0xFF4A5DD8),
    700: Color(0xFF3A4BC4),
    800: Color(0xFF2C3AB0),
    900: Color(0xFF1A2190),
  });

  static LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, secondaryPurple],
  );

  static LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, secondaryPurple],
  );
}