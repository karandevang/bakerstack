// lib/config/api_config.dart
/// API Configuration for BakerStack Backend Integration
///
/// This file contains all API endpoints and configuration settings
/// for connecting to the FastAPI backend.
///
/// Update baseUrl based on your device:
/// - Android Emulator: http://10.0.2.2:8000
/// - iOS Simulator: http://localhost:8000
/// - Physical Device: http://YOUR_COMPUTER_IP:8000

class ApiConfig {
  // ============================================
  // Base URL Configuration
  // ============================================

  /// Base URL for backend API
  /// ⚠️ CHANGE THIS BASED ON YOUR DEVICE
  static const String baseUrl = 'http://10.0.2.2:8000';  // Android Emulator (DEFAULT)
  // static const String baseUrl = 'http://localhost:8000';  // iOS Simulator
  // static const String baseUrl = 'http://192.168.1.5:8000';  // Physical Device (replace with your IP)

  // ============================================
  // API Version
  // ============================================

  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // ============================================
  // API Endpoints - Authentication
  // ============================================

  static const String authRegister = '/api/auth/register';
  static const String authLogin = '/api/auth/login';
  static const String authLogout = '/api/auth/logout';
  static const String authMe = '/api/auth/me';
  static const String authRefresh = '/api/auth/refresh';

  // ============================================
  // API Endpoints - Products
  // ============================================

  static const String products = '/api/products';

  /// Get product by ID
  static String productById(int id) => '/api/products/$id';

  /// Get products with filters
  static String productsWithFilters({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    int skip = 0,
    int limit = 100,
  }) {
    final params = <String>[];

    if (category != null && category.isNotEmpty) {
      params.add('category=${Uri.encodeComponent(category)}');
    }
    if (search != null && search.isNotEmpty) {
      params.add('search=${Uri.encodeComponent(search)}');
    }
    if (minPrice != null) {
      params.add('min_price=$minPrice');
    }
    if (maxPrice != null) {
      params.add('max_price=$maxPrice');
    }
    if (inStock != null) {
      params.add('in_stock=$inStock');
    }
    params.add('skip=$skip');
    params.add('limit=$limit');

    return '$products?${params.join('&')}';
  }

  /// Search products by name
  static String searchProducts(String query) {
    return '$products?search=${Uri.encodeComponent(query)}';
  }

  /// Get products by category
  static String productsByCategory(String category) {
    return '$products?category=${Uri.encodeComponent(category)}';
  }

  // ============================================
  // API Endpoints - Shopping Cart
  // ============================================

  static const String cart = '/api/cart';
  static const String cartAdd = '/api/cart/add';
  static const String cartUpdate = '/api/cart/update';
  static const String cartClear = '/api/cart/clear';

  /// Update cart item quantity
  static String cartItemUpdate(int cartItemId) => '/api/cart/$cartItemId';

  /// Delete cart item by ID
  static String cartItemDelete(int cartItemId) => '/api/cart/$cartItemId';

  /// Get cart item count
  static const String cartCount = '/api/cart/count';

  // ============================================
  // API Endpoints - Wishlist
  // ============================================

  static const String wishlist = '/api/wishlist';
  static const String wishlistAdd = '/api/wishlist/add';

  /// Delete wishlist item by ID
  static String wishlistItemDelete(int wishlistItemId) => '/api/wishlist/$wishlistItemId';

  /// Check if product is in wishlist
  static String wishlistCheck(int productId) => '/api/wishlist/check/$productId';

  /// Get wishlist count
  static const String wishlistCount = '/api/wishlist/count';

  // ============================================
  // API Endpoints - Orders
  // ============================================

  static const String orders = '/api/orders';
  static const String ordersCreate = '/api/orders';

  /// Get order by ID
  static String orderById(int orderId) => '/api/orders/$orderId';

  /// Cancel order by ID
  static String orderCancel(int orderId) => '/api/orders/$orderId/cancel';

  /// Update order status (admin only)
  static String orderUpdateStatus(int orderId) => '/api/orders/$orderId/status';

  /// Get orders with filters
  static String ordersWithFilters({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int skip = 0,
    int limit = 100,
  }) {
    final params = <String>[];

    if (status != null && status.isNotEmpty) {
      params.add('status=${Uri.encodeComponent(status)}');
    }
    if (startDate != null) {
      params.add('start_date=${startDate.toIso8601String()}');
    }
    if (endDate != null) {
      params.add('end_date=${endDate.toIso8601String()}');
    }
    params.add('skip=$skip');
    params.add('limit=$limit');

    return '$orders?${params.join('&')}';
  }

  /// Get order statistics
  static const String orderStats = '/api/orders/stats';

  // ============================================
  // API Endpoints - Addresses
  // ============================================

  static const String addresses = '/api/addresses';
  static const String addressesCreate = '/api/addresses';

  /// Get address by ID
  static String addressById(int addressId) => '/api/addresses/$addressId';

  /// Update address by ID
  static String addressUpdate(int addressId) => '/api/addresses/$addressId';

  /// Delete address by ID
  static String addressDelete(int addressId) => '/api/addresses/$addressId';

  /// Set default address
  static String addressSetDefault(int addressId) => '/api/addresses/$addressId/set-default';

  /// Get default address
  static const String addressDefault = '/api/addresses/default';

  // ============================================
  // API Endpoints - Profile
  // ============================================

  static const String profile = '/api/profile';
  static const String profileUpdate = '/api/profile';
  static const String profileAvatar = '/api/profile/avatar';
  static const String profileChangePassword = '/api/profile/change-password';
  static const String profileDelete = '/api/profile/delete';

  // ============================================
  // API Endpoints - Marketplace
  // ============================================

  static const String marketplaceListings = '/api/marketplace/listings';
  static const String marketplaceCreate = '/api/marketplace/listings';

  /// Get marketplace listing by ID
  static String marketplaceListingById(int listingId) => '/api/marketplace/listings/$listingId';

  /// Update marketplace listing
  static String marketplaceUpdate(int listingId) => '/api/marketplace/listings/$listingId';

  /// Delete marketplace listing
  static String marketplaceDelete(int listingId) => '/api/marketplace/listings/$listingId';

  /// Get user's marketplace listings
  static const String marketplaceMyListings = '/api/marketplace/my-listings';

  /// Mark listing as sold
  static String marketplaceMarkSold(int listingId) => '/api/marketplace/listings/$listingId/mark-sold';

  /// Mark listing as available
  static String marketplaceMarkAvailable(int listingId) => '/api/marketplace/listings/$listingId/mark-available';

  /// Get marketplace listings with filters
  static String marketplaceWithFilters({
    String? condition,
    double? minPrice,
    double? maxPrice,
    bool? isSold,
    int skip = 0,
    int limit = 100,
  }) {
    final params = <String>[];

    if (condition != null && condition.isNotEmpty) {
      params.add('condition=${Uri.encodeComponent(condition)}');
    }
    if (minPrice != null) {
      params.add('min_price=$minPrice');
    }
    if (maxPrice != null) {
      params.add('max_price=$maxPrice');
    }
    if (isSold != null) {
      params.add('is_sold=$isSold');
    }
    params.add('skip=$skip');
    params.add('limit=$limit');

    return '$marketplaceListings?${params.join('&')}';
  }

  // ============================================
  // API Endpoints - Business Details
  // ============================================

  static const String businessDetails = '/api/business-details';

  // ============================================
  // API Endpoints - Reviews (Future)
  // ============================================

  static const String reviews = '/api/reviews';
  static String reviewsByProduct(int productId) => '/api/reviews/product/$productId';
  static String reviewById(int reviewId) => '/api/reviews/$reviewId';

  // ============================================
  // API Endpoints - Notifications (Future)
  // ============================================

  static const String notifications = '/api/notifications';
  static const String notificationsUnread = '/api/notifications/unread';
  static String notificationMarkRead(int notificationId) => '/api/notifications/$notificationId/read';
  static const String notificationsMarkAllRead = '/api/notifications/mark-all-read';

  // ============================================
  // API Endpoints - Analytics (Admin)
  // ============================================

  static const String analytics = '/api/analytics';
  static const String analyticsDashboard = '/api/analytics/dashboard';
  static const String analyticsProducts = '/api/analytics/products';
  static const String analyticsOrders = '/api/analytics/orders';
  static const String analyticsRevenue = '/api/analytics/revenue';

  // ============================================
  // Configuration Constants
  // ============================================

  /// Request timeout duration
  static const Duration requestTimeout = Duration(seconds: 30);

  /// Connection timeout duration
  static const Duration connectionTimeout = Duration(seconds: 30);

  /// Receive timeout duration
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Max retry attempts for failed requests
  static const int maxRetries = 3;

  /// Retry delay
  static const Duration retryDelay = Duration(seconds: 2);

  // ============================================
  // HTTP Headers
  // ============================================

  /// Default headers (no authentication)
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'BakerStack-Mobile/1.0.0',
  };

  /// Headers with authentication token
  static Map<String, String> authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'User-Agent': 'BakerStack-Mobile/1.0.0',
  };

  /// Headers for multipart form data (file uploads)
  static Map<String, String> multipartHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'User-Agent': 'BakerStack-Mobile/1.0.0',
  };

  // ============================================
  // Helper Methods
  // ============================================

  /// Get full URL for an endpoint
  static String getUrl(String endpoint) {
    // Remove leading slash if present to avoid double slashes
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '$baseUrl/$cleanEndpoint';
  }

  /// Get environment name
  static String get environmentName {
    if (baseUrl.contains('localhost') ||
        baseUrl.contains('10.0.2.2') ||
        baseUrl.contains('127.0.0.1')) {
      return 'Development';
    }
    return 'Production';
  }

  /// Check if using local development
  static bool get isLocalDevelopment {
    return baseUrl.contains('localhost') ||
        baseUrl.contains('10.0.2.2') ||
        baseUrl.contains('127.0.0.1');
  }

  /// Check if using production
  static bool get isProduction => !isLocalDevelopment;

  /// Validate base URL configuration
  static bool validateConfiguration() {
    try {
      final uri = Uri.parse(baseUrl);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  /// Print configuration (for debugging)
  static void printConfiguration() {
    print('╔════════════════════════════════════════╗');
    print('║     BakerStack API Configuration      ║');
    print('╠════════════════════════════════════════╣');
    print('║ Base URL: $baseUrl');
    print('║ Environment: $environmentName');
    print('║ Timeout: ${requestTimeout.inSeconds}s');
    print('║ Max Retries: $maxRetries');
    print('║ Valid Config: ${validateConfiguration()}');
    print('╚════════════════════════════════════════╝');
  }

  // ============================================
  // Test Credentials (Development Only)
  // ============================================

  /// ⚠️ REMOVE THESE IN PRODUCTION
  static const String testPhone1 = '9876543210';
  static const String testEmail1 = 'karan@bakerstack.com';
  static const String testPassword = 'password123';

  static const String testPhone2 = '9876543211';
  static const String testEmail2 = 'priya@bakerstack.com';

  static const String testPhone3 = '9876543212';
  static const String testEmail3 = 'rajesh@bakerstack.com';

  // ============================================
  // Product Categories
  // ============================================

  static const List<String> productCategories = [
    'Packaging',
    'Raw Materials',
    'Tools',
    'Decorations',
  ];

  /// Get category icon
  static String getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'packaging':
        return '📦';
      case 'raw materials':
        return '🌾';
      case 'tools':
        return '🔧';
      case 'decorations':
        return '🎂';
      default:
        return '📋';
    }
  }

  // ============================================
  // Order Status
  // ============================================

  static const List<String> orderStatuses = [
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  /// Get order status display name
  static String getOrderStatusDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  // ============================================
  // Marketplace Conditions
  // ============================================

  static const List<String> equipmentConditions = [
    'Excellent',
    'Good',
    'Fair',
    'Poor',
  ];

  /// Get condition emoji
  static String getConditionEmoji(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
        return '⭐';
      case 'good':
        return '✅';
      case 'fair':
        return '👍';
      case 'poor':
        return '⚠️';
      default:
        return '❓';
    }
  }

  // ============================================
  // Error Messages
  // ============================================

  static const String networkErrorMessage = 'Network error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unauthorizedMessage = 'Session expired. Please login again.';
  static const String notFoundMessage = 'Resource not found.';
  static const String timeoutMessage = 'Request timeout. Please try again.';
  static const String unknownErrorMessage = 'An unexpected error occurred.';

  // ============================================
  // Pagination
  // ============================================

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ============================================
  // Cache Settings
  // ============================================

  static const Duration cacheExpiration = Duration(minutes: 5);
  static const int maxCacheSize = 50; // Number of cached responses

  // ============================================
  // File Upload Settings
  // ============================================

  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const int imageQuality = 80; // 0-100

  // ============================================
  // App Info
  // ============================================

  static const String appName = 'BakerStack';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
}