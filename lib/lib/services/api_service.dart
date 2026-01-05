// lib/services/api_service.dart
/// Main API Service for BakerStack Backend
///
/// Handles all HTTP requests with proper error handling,
/// authentication, and response parsing.

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  // ============================================
  // Singleton Pattern
  // ============================================

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // ============================================
  // Authentication Token
  // ============================================

  String? _token;

  /// Set authentication token
  void setToken(String? token) {
    _token = token;
    if (token != null) {
      print('🔑 Token set: ${token.substring(0, 20)}...');
    } else {
      print('🔑 Token cleared');
    }
  }

  /// Get current token
  String? get token => _token;

  /// Check if user is authenticated
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  // ============================================
  // HTTP Methods
  // ============================================

  /// GET request
  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, String>? queryParameters,
        bool auth = false,
      }) async {
    try {
      final url = _buildUrl(endpoint, queryParameters);
      final headers = _buildHeaders(auth);

      print('📡 GET: $url');

      final response = await http
          .get(url, headers: headers)
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      return _errorResponse('No internet connection');
    } on TimeoutException {
      return _errorResponse('Request timeout. Please try again.');
    } catch (e) {
      return _errorResponse('Error: ${e.toString()}');
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body, {
        bool auth = false,
      }) async {
    try {
      final url = _buildUrl(endpoint, null);
      final headers = _buildHeaders(auth);

      print('📡 POST: $url');
      print('📦 Body: $body');

      final response = await http
          .post(
        url,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      return _errorResponse('No internet connection');
    } on TimeoutException {
      return _errorResponse('Request timeout. Please try again.');
    } catch (e) {
      return _errorResponse('Error: ${e.toString()}');
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> body, {
        bool auth = false,
      }) async {
    try {
      final url = _buildUrl(endpoint, null);
      final headers = _buildHeaders(auth);

      print('📡 PUT: $url');
      print('📦 Body: $body');

      final response = await http
          .put(
        url,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      return _errorResponse('No internet connection');
    } on TimeoutException {
      return _errorResponse('Request timeout. Please try again.');
    } catch (e) {
      return _errorResponse('Error: ${e.toString()}');
    }
  }

  /// PATCH request
  Future<Map<String, dynamic>> patch(
      String endpoint,
      Map<String, dynamic> body, {
        bool auth = false,
      }) async {
    try {
      final url = _buildUrl(endpoint, null);
      final headers = _buildHeaders(auth);

      print('📡 PATCH: $url');
      print('📦 Body: $body');

      final response = await http
          .patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      return _errorResponse('No internet connection');
    } on TimeoutException {
      return _errorResponse('Request timeout. Please try again.');
    } catch (e) {
      return _errorResponse('Error: ${e.toString()}');
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
      String endpoint, {
        bool auth = false,
      }) async {
    try {
      final url = _buildUrl(endpoint, null);
      final headers = _buildHeaders(auth);

      print('📡 DELETE: $url');

      final response = await http
          .delete(url, headers: headers)
          .timeout(ApiConfig.requestTimeout);

      return _handleResponse(response);
    } on SocketException {
      return _errorResponse('No internet connection');
    } on TimeoutException {
      return _errorResponse('Request timeout. Please try again.');
    } catch (e) {
      return _errorResponse('Error: ${e.toString()}');
    }
  }

  // ============================================
  // Helper Methods
  // ============================================

  /// Build URL with query parameters
  Uri _buildUrl(String endpoint, Map<String, String>? queryParameters) {
    final fullUrl = ApiConfig.getUrl(endpoint);
    final uri = Uri.parse(fullUrl);

    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(queryParameters: queryParameters);
    }

    return uri;
  }

  /// Build request headers
  Map<String, String> _buildHeaders(bool auth) {
    if (auth && _token != null) {
      return ApiConfig.authHeaders(_token!);
    }
    return ApiConfig.defaultHeaders;
  }

  /// Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    print('📨 Response: ${response.statusCode}');
    print('📄 Body: ${response.body.length > 200 ? "${response.body.substring(0, 200)}..." : response.body}');

    // Success responses (200-299)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (response.body.isEmpty) {
          return {'success': true, 'data': null};
        }
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } catch (e) {
        print('⚠️ Response parsing error: $e');
        return {'success': true, 'data': response.body};
      }
    }

    // Error responses (400+)
    try {
      final error = jsonDecode(response.body);
      final errorMessage = error['detail'] ??
          error['message'] ??
          'Request failed';
      return {
        'success': false,
        'error': errorMessage,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Request failed with status ${response.statusCode}',
        'statusCode': response.statusCode,
      };
    }
  }

  /// Create error response
  Map<String, dynamic> _errorResponse(String message) {
    print('❌ Error: $message');
    return {
      'success': false,
      'error': message,
    };
  }

  // ============================================
  // Utility Methods
  // ============================================

  /// Clear authentication token
  void clearToken() {
    _token = null;
    print('🔓 Token cleared');
  }

  /// Check if endpoint requires authentication
  bool requiresAuth(String endpoint) {
    final noAuthEndpoints = [
      ApiConfig.authLogin,
      ApiConfig.authRegister,
      ApiConfig.products,
      ApiConfig.marketplaceListings,
    ];

    return !noAuthEndpoints.any((e) => endpoint.contains(e));
  }

  /// Log request for debugging
  void logRequest(String method, String endpoint, {Map<String, dynamic>? body}) {
    print('═══════════════════════════════════════');
    print('📡 $method Request');
    print('🔗 Endpoint: $endpoint');
    print('🔐 Auth: ${_token != null ? "Yes" : "No"}');
    if (body != null) {
      print('📦 Body: ${jsonEncode(body)}');
    }
    print('═══════════════════════════════════════');
  }

  /// Log response for debugging
  void logResponse(Map<String, dynamic> response) {
    print('═══════════════════════════════════════');
    print('📨 Response');
    print('✅ Success: ${response['success']}');
    if (response['success']) {
      print('📦 Data: ${response['data']}');
    } else {
      print('❌ Error: ${response['error']}');
    }
    print('═══════════════════════════════════════');
  }
}