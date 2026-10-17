// lib/services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();

  User? _currentUser;
  String? _token;
  int? _userId;

  User? get currentUser => _currentUser;
  String? get token => _token;
  int? get userId => _userId;
  bool get isAuthenticated => _token != null;

  // ============================================================================
  // AUTHENTICATION METHODS
  // ============================================================================

  /// Login with phone and password
  Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      print('📱 Attempting login with phone: $phone');

      final response = await _apiService.post(
        ApiConfig.authLogin,
        {
          'phone': phone,
          'password': password,
        },
        auth: false, // ✅ No auth needed for login
      );

      print('📦 Login response: $response');

      if (response['success']) {
        return await _handleAuthResponse(response['data'], 'login');
      } else {
        print('❌ Login failed: ${response['error']}');
        return {
          'success': false,
          'error': response['error'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('❌ Login error: $e');
      return {
        'success': false,
        'error': 'Login error: $e',
      };
    }
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      print('📝 Attempting registration for: $phone');

      final response = await _apiService.post(
        ApiConfig.authRegister,
        {
          'full_name': fullName,
          'phone': phone,
          'email': email,
          'password': password,
        },
        auth: false, // ✅ No auth needed for registration
      );

      print('📦 Register response: $response');

      if (response['success']) {
        return await _handleAuthResponse(response['data'], 'register');
      } else {
        print('❌ Registration failed: ${response['error']}');
        return {
          'success': false,
          'error': response['error'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      print('❌ Registration error: $e');
      return {
        'success': false,
        'error': 'Registration error: $e',
      };
    }
  }

  /// Handle authentication response (common logic for login/register)
  Future<Map<String, dynamic>> _handleAuthResponse(
      Map<String, dynamic> data,
      String operation,
      ) async {
    try {
      // Extract token
      _token = data['access_token'] as String?;

      if (_token == null || _token!.isEmpty) {
        print('❌ No access token in $operation response');
        return {
          'success': false,
          'error': 'No access token received from server',
        };
      }

      print('🔑 Token received: ${_token!.substring(0, 20)}...');

      // Set token in API service
      _apiService.setToken(_token!);

      // Extract user data
      final userData = data['user'];
      print('👤 User data: $userData');

      if (userData == null) {
        print('❌ No user data in $operation response');
        return {
          'success': false,
          'error': 'No user data received from server',
        };
      }

      // Parse user
      try {
        _currentUser = User.fromJson(userData);
        _userId = _currentUser!.id;
        print('✅ User parsed successfully: ${_currentUser!.fullName} (ID: $_userId)');
      } catch (e) {
        print('❌ Error parsing user: $e');
        print('User data was: $userData');
        return {
          'success': false,
          'error': 'Failed to parse user data: $e',
        };
      }

      // Save session
      await _saveSession();
      print('💾 Session saved');

      return {
        'success': true,
        'user': _currentUser,
        'token': _token,
      };
    } catch (e) {
      print('❌ Error handling auth response: $e');
      return {
        'success': false,
        'error': 'Failed to process authentication: $e',
      };
    }
  }

  /// Get current user from backend
  Future<User?> getCurrentUser() async {
    try {
      if (_token == null) {
        print('❌ No token available for getCurrentUser');
        return null;
      }

      print('🔄 Fetching current user from backend...');

      final response = await _apiService.get(
        ApiConfig.authMe,
        auth: true, // ✅ Requires authentication
      );

      if (response['success']) {
        final userData = response['data'];
        _currentUser = User.fromJson(userData);
        _userId = _currentUser!.id;
        await _saveSession();
        print('✅ Current user fetched: ${_currentUser!.fullName}');
        return _currentUser;
      } else {
        print('❌ Failed to get current user: ${response['error']}');
        return null;
      }
    } catch (e) {
      print('❌ Get current user error: $e');
      return null;
    }
  }

  /// Refresh authentication token
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      if (_token == null) {
        return {
          'success': false,
          'error': 'No token to refresh',
        };
      }

      print('🔄 Refreshing token...');

      final response = await _apiService.post(
        ApiConfig.authRefresh,
        {},
        auth: true, // ✅ Requires authentication
      );

      if (response['success']) {
        final newToken = response['data']['access_token'] as String?;

        if (newToken != null) {
          _token = newToken;
          _apiService.setToken(newToken);
          await _saveSession();
          print('✅ Token refreshed successfully');

          return {
            'success': true,
            'token': newToken,
          };
        }
      }

      return {
        'success': false,
        'error': 'Failed to refresh token',
      };
    } catch (e) {
      print('❌ Token refresh error: $e');
      return {
        'success': false,
        'error': 'Token refresh error: $e',
      };
    }
  }

  // ============================================================================
  // PROFILE MANAGEMENT
  // ============================================================================

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String email,
  }) async {
    try {
      print('📝 Updating profile...');

      final response = await _apiService.put(
        ApiConfig.profileUpdate,
        {
          'full_name': fullName,
          'email': email,
        },
        auth: true, // ✅ Requires authentication
      );

      if (response['success']) {
        final userData = response['data'];
        _currentUser = User.fromJson(userData);
        await _saveSession();
        print('✅ Profile updated successfully');

        return {
          'success': true,
          'user': _currentUser,
        };
      }

      return response;
    } catch (e) {
      print('❌ Update profile error: $e');
      return {
        'success': false,
        'error': 'Failed to update profile: $e',
      };
    }
  }

  /// Change password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      print('🔐 Changing password...');

      final response = await _apiService.post(
        ApiConfig.profileChangePassword,
        {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        auth: true, // ✅ Requires authentication
      );

      if (response['success']) {
        print('✅ Password changed successfully');
      } else {
        print('❌ Password change failed: ${response['error']}');
      }

      return response;
    } catch (e) {
      print('❌ Change password error: $e');
      return {
        'success': false,
        'error': 'Failed to change password: $e',
      };
    }
  }

  /// Delete account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      print('🗑️ Deleting account...');

      final response = await _apiService.delete(
        ApiConfig.profileDelete,
        auth: true, // ✅ Requires authentication
      );

      if (response['success']) {
        await logout();
        print('✅ Account deleted successfully');
      }

      return response;
    } catch (e) {
      print('❌ Delete account error: $e');
      return {
        'success': false,
        'error': 'Failed to delete account: $e',
      };
    }
  }

  // ============================================================================
  // SESSION MANAGEMENT
  // ============================================================================

  /// Save session to SharedPreferences
  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_token != null) {
        await prefs.setString('auth_token', _token!);
        print('💾 Token saved to storage');
      }

      if (_currentUser != null) {
        await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));
        await prefs.setInt('user_id', _currentUser!.id);
        print('💾 User data saved to storage');
      }

      print('✅ Session saved to SharedPreferences');
    } catch (e) {
      print('❌ Error saving session: $e');
    }
  }

  /// Load session from SharedPreferences
  Future<bool> loadSession() async {
    try {
      print('🔄 Loading session from storage...');
      final prefs = await SharedPreferences.getInstance();

      _token = prefs.getString('auth_token');
      final userJson = prefs.getString('user_data');
      _userId = prefs.getInt('user_id');

      if (_token != null && userJson != null) {
        _apiService.setToken(_token!);
        _currentUser = User.fromJson(jsonDecode(userJson));
        print('✅ Session loaded successfully');
        print('   - User: ${_currentUser!.fullName}');
        print('   - User ID: $_userId');
        print('   - Token: ${_token!.substring(0, 20)}...');
        return true;
      }

      print('⚠️ No saved session found');
      return false;
    } catch (e) {
      print('❌ Error loading session: $e');
      return false;
    }
  }

  /// Clear session
  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.remove('user_id');

      print('✅ Session cleared from storage');
    } catch (e) {
      print('❌ Error clearing session: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      print('👋 Logging out...');

      // Call logout endpoint if token exists
      if (_token != null) {
        try {
          await _apiService.post(
            ApiConfig.authLogout,
            {},
            auth: true, // ✅ Requires authentication
          );
          print('✅ Server logout successful');
        } catch (e) {
          print('⚠️ Server logout failed (will continue with local logout): $e');
        }
      }

      // Clear local session
      await _clearSession();

      // Clear instance variables
      _token = null;
      _currentUser = null;
      _userId = null;
      _apiService.clearToken();

      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  /// Check if session is valid (not expired)
  Future<bool> validateSession() async {
    try {
      if (_token == null) {
        return false;
      }

      // Try to get current user to validate token
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      print('❌ Session validation error: $e');
      return false;
    }
  }

  // ============================================================================
  // VALIDATION HELPERS
  // ============================================================================

  /// Validate phone number format
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    // Remove any spaces or dashes
    final cleanPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
    // Check if it's exactly 10 digits
    return cleanPhone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(cleanPhone);
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Get password strength indicator
  static String getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Too short';
    if (password.length < 8) return 'Weak';

    int strength = 0;

    // Check for lowercase
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;

    // Check for uppercase
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;

    // Check for numbers
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;

    // Check for special characters
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    if (password.length >= 12 && strength >= 3) return 'Strong';
    if (password.length >= 10 && strength >= 2) return 'Medium';
    return 'Weak';
  }

  /// Get password strength score (0-3)
  static int getPasswordStrengthScore(String password) {
    if (password.isEmpty) return 0;
    if (password.length < 6) return 0;

    final strength = getPasswordStrength(password);

    switch (strength) {
      case 'Too short':
        return 0;
      case 'Weak':
        return 1;
      case 'Medium':
        return 2;
      case 'Strong':
        return 3;
      default:
        return 0;
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get authentication status message
  String getAuthStatusMessage() {
    if (!isAuthenticated) {
      return 'Not authenticated';
    }

    if (_currentUser != null) {
      return 'Authenticated as ${_currentUser!.fullName}';
    }

    return 'Authenticated';
  }

  /// Print authentication status (for debugging)
  void printAuthStatus() {
    print('╔════════════════════════════════════════╗');
    print('║      Authentication Status             ║');
    print('╠════════════════════════════════════════╣');
    print('║ Authenticated: $isAuthenticated');
    print('║ User: ${_currentUser?.fullName ?? 'None'}');
    print('║ User ID: ${_userId ?? 'None'}');
    print('║ Token: ${_token != null ? '${_token!.substring(0, 20)}...' : 'None'}');
    print('╚════════════════════════════════════════╝');
  }
}