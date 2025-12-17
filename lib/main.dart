import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lib/services/auth_service.dart';
import 'lib/services/api_service.dart';  // ← ADD THIS IMPORT
import 'lib/screens/login_screen.dart';
import 'lib/screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(  // ← CHANGE: ChangeNotifierProvider → MultiProvider
      providers: [
        // AuthService Provider
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        // ApiService Provider - ADD THIS!
        ProxyProvider<AuthService, ApiService>(
          update: (context, authService, previous) => ApiService(authService),
        ),
      ],
      child: BakerStackApp(),
    ),
  );
}

class BakerStackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BakerStack',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF667eea, {
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
        }),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AuthService>(context, listen: false).initialize(),
      builder: (context, snapshot) {
        // Show loading screen while checking auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('🛒', style: TextStyle(fontSize: 60)),
                      ),
                    ),
                    SizedBox(height: 40),
                    // Loading indicator
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Show appropriate screen based on auth status
        return Consumer<AuthService>(
          builder: (context, authService, _) {
            if (authService.isAuthenticated) {
              return MainScreen();
            } else {
              return LoginScreen();
            }
          },
        );
      },
    );
  }
}