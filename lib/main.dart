// lib/main.dart
import 'package:bakerstack/screens/cart_screen.dart';
import 'package:bakerstack/screens/checkout_screen.dart';
import 'package:bakerstack/screens/create_listing_screen.dart';
import 'package:bakerstack/screens/delivery_addresses_screen.dart';
import 'package:bakerstack/screens/edit_profile_screen.dart';

import 'package:bakerstack/screens/home_screen.dart';
import 'package:bakerstack/screens/login_screen.dart';
import 'package:bakerstack/screens/marketplace_detail_screen.dart';
import 'package:bakerstack/screens/marketplace_feed_screen.dart';
import 'package:bakerstack/screens/my_listing_screen.dart';
import 'package:bakerstack/screens/notifications_screen.dart';
import 'package:bakerstack/screens/order_detail_screen.dart';
import 'package:bakerstack/screens/order_history_screen.dart';
import 'package:bakerstack/screens/product_detail_screen.dart';
import 'package:bakerstack/screens/profile_screen.dart';
import 'package:bakerstack/screens/register_screen.dart';
import 'package:bakerstack/screens/splash_screen.dart';
import 'package:bakerstack/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Screens
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const BakerStackApp());
}

class BakerStackApp extends StatelessWidget {
  const BakerStackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BakerStack',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: ThemeData(
        primaryColor: const Color(0xFF7B2CBF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B2CBF),
          primary: const Color(0xFF7B2CBF),
          secondary: const Color(0xFF9D4EDD),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF7B2CBF),
          foregroundColor: Colors.white,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),

        // ElevatedButton Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B2CBF),
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // TextButton Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF7B2CBF),
          ),
        ),

        // OutlinedButton Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF7B2CBF),
            side: const BorderSide(color: Color(0xFF7B2CBF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // InputDecoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF7B2CBF), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),

        // Card Theme
        // CORRECT VERSION - Replace in main.dart

        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),

        // FloatingActionButton Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF7B2CBF),
          foregroundColor: Colors.white,
          elevation: 4,
        ),

        // SnackBar Theme
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentTextStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        // Dialog Theme
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
        ),

        // Bottom Sheet Theme
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: Colors.white,
        ),

        // Divider Theme
        dividerTheme: DividerThemeData(
          color: Colors.grey[300],
          thickness: 1,
        ),
      ),

      // Initial Route
      initialRoute: '/',

      // Routes
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/order-history': (context) => const OrderHistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/addresses': (context) => const DeliveryAddressesScreen(),
        '/marketplace': (context) => const MarketplaceFeedScreen(),
        '/create-listing': (context) => const CreateListingScreen(),
        '/my-listings': (context) => const MyListingsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },

      // On Generate Route (for routes with arguments)
      onGenerateRoute: (settings) {
        // Product Detail Screen
        if (settings.name == '/product-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: args['productId'] as int,
            ),
          );
        }

        // Order Detail Screen
        if (settings.name == '/order-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
              orderId: args['orderId'] as int,
            ),
          );
        }

        // Marketplace Detail Screen
        if (settings.name == '/marketplace-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => MarketplaceDetailScreen(
              listingId: args['listingId'] as int,
            ),
          );
        }

        // Unknown route
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        );
      },

      // Unknown Route Handler
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        );
      },
    );
  }
}

// 404 Not Found Screen
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7B2CBF), Color(0xFF9D4EDD)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 120,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The page you are looking for doesn\'t exist.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('GO TO HOME'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7B2CBF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}