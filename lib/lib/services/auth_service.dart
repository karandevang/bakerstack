// lib/services/auth_service.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  // API Configuration
  // Change this based on your setup:
  // Android Emulator: http://10.0.2.2:8000/api/v1
  // iOS Simulator: http://localhost:8000/api/v1
  // Real Device: http://YOUR_COMPUTER_IP:8000/api/v1
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  String? _token;
  Map<String, dynamic>? _user;
  bool _isAuthenticated = false;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  String get userName => _user?['full_name'] ?? 'User';
  String get userPhone => _user?['phone'] ?? '';
  String get userEmail => _user?['email'] ?? '';

  /// Initialize - Load token from storage on app start
  Future<void> initialize() async {
    try {
      print('🔄 Initializing AuthService...');
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      final userJson = prefs.getString('user');

      if (_token != null && userJson != null) {
        _user = jsonDecode(userJson);
        _isAuthenticated = true;
        print('✅ User authenticated: ${_user?['full_name']}');
      } else {
        print('ℹ️ No saved credentials found');
        _isAuthenticated = false;
      }
      notifyListeners();
    } catch (e) {
      print('❌ Initialize error: $e');
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Login with phone number and password
  Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      print('📤 Attempting login for: $phoneNumber');
      print('📡 API URL: $baseUrl/auth/login');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phoneNumber,
          'password': password,
        }),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout. Please check if backend is running.');
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        _user = data['user'];
        _isAuthenticated = true;

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_user));

        print('✅ Login successful: ${_user?['full_name']}');
        print('🔑 Token saved');
        notifyListeners();
        return data;
      } else {
        final error = jsonDecode(response.body);
        final errorMessage = error['detail'] ?? 'Login failed';
        print('❌ Login failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Login error: $e');
      if (e.toString().contains('Failed host lookup') ||
          e.toString().contains('SocketException')) {
        throw Exception('Cannot connect to server. Please check:\n1. Backend is running\n2. Base URL is correct\n3. Network connection');
      }
      if (e.toString().contains('timeout')) {
        throw Exception('Connection timeout. Backend may not be running.');
      }
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String phoneNumber,
    required String password,
    required String fullName,
  }) async {
    try {
      print('📤 Attempting registration for: $phoneNumber');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phoneNumber,
          'password': password,
          'full_name': fullName,
        }),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Registration successful');
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Registration failed');
      }
    } catch (e) {
      print('❌ Registration error: $e');
      throw Exception('Registration error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  /// Send OTP to phone number
  Future<void> sendOTP(String phoneNumber) async {
    try {
      print('📤 Sending OTP to: $phoneNumber');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber}),
      );

      if (response.statusCode == 200) {
        print('✅ OTP sent successfully');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      print('❌ Send OTP error: $e');
      throw Exception('Send OTP error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      print('📤 Verifying OTP for: $phoneNumber');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phoneNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        _user = data['user'];
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_user));

        print('✅ OTP verified successfully');
        notifyListeners();
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Invalid OTP');
      }
    } catch (e) {
      print('❌ Verify OTP error: $e');
      throw Exception('Verify OTP error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  /// Logout
  Future<void> logout() async {
    print('👋 Logging out user: ${_user?['full_name']}');

    _token = null;
    _user = null;
    _isAuthenticated = false;

    // Remove from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    print('✅ User logged out');
    notifyListeners();
  }

  /// Get authorization header for API requests
  Map<String, String> getAuthHeaders() {
    if (_token == null) {
      throw Exception('Not authenticated. Please login.');
    }
    return {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    };
  }

  /// Check if token is valid (optional - for future use)
  Future<bool> validateToken() async {
    if (_token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ Token is valid');
        return true;
      } else {
        print('⚠️ Token is invalid');
        return false;
      }
    } catch (e) {
      print('❌ Token validation error: $e');
      return false;
    }
  }

  /// Generic GET request with auth
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Request failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('GET error: $e');
    }
  }

  /// Generic POST request with auth
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: getAuthHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Request failed');
      }
    } catch (e) {
      throw Exception('POST error: $e');
    }
  }

  /// Generic DELETE request with auth
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Request failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('DELETE error: $e');
    }
  }
}