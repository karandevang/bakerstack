import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGradientStart = Color(0xFF667eea);
  static const Color primaryGradientEnd = Color(0xFF764ba2);
  static const Color accentRed = Color(0xFFff6b6b);
  static const Color accentRedDark = Color(0xFFee5a52);

  static const MaterialColor primaryMaterialColor = MaterialColor(0xFF667eea, {
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

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradientStart, primaryGradientEnd],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
  );

  static const LinearGradient fabGradient = LinearGradient(
    colors: [accentRed, accentRedDark],
  );
}

class AppStrings {
  static const String appName = 'BakerStack';
  static const String userName = 'chandan m k';
  static const String searchHint = 'Search...';
  static const String categoriesTitle = 'Categories';
  static const String viewAll = 'View all';
  static const String recommendedProducts = 'Recommended Products For You';
  static const String wishlist = 'Wishlist';
  static const String myCart = 'My Cart';
  static const String notifications = 'Notifications';
  static const String orderHistory = 'Order History';
  static const String profile = 'Profile';
}