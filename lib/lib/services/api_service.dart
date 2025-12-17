// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart_item.dart';
import 'auth_service.dart';

class ApiService {
  final AuthService authService;

  // Use same base URL as AuthService
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  ApiService(this.authService);

  // ==================== PRODUCT METHODS ====================
  Future<List<Product>> getProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      print('📤 Getting products...');

      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      if (category != null) queryParams['category'] = category;
      if (minPrice != null) queryParams['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
      if (search != null) queryParams['search'] = search;

      final uri = Uri.parse('$baseUrl/products').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      print('📥 Products response: ${response.statusCode}');
      print('📥 Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ FIX: Check if response is a Map with 'products' key or a List
        List<dynamic> productsJson;

        if (data is Map<String, dynamic> && data.containsKey('products')) {
          // Response format: {"products": [...], "total": 10}
          productsJson = data['products'] as List<dynamic>;
        } else if (data is List) {
          // Response format: [...]
          productsJson = data;
        } else {
          print('❌ Unexpected response format: $data');
          throw Exception('Unexpected API response format');
        }

        final products = productsJson.map((json) {
          try {
            return Product.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print('❌ Error parsing product: $json');
            print('❌ Parse error: $e');
            rethrow;
          }
        }).toList();

        print('✅ Loaded ${products.length} products');
        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Get products error: $e');
      throw Exception('Failed to load products: $e');
    }
  }
  /// Get single product by ID
  Future<Product> getProduct(String productId) async {
    try {
      print('📤 Getting product: $productId');

      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId'),
      );

      if (response.statusCode == 200) {
        print('✅ Product loaded');
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      print('❌ Get product error: $e');
      throw Exception('Failed to load product: $e');
    }
  }

  // ==================== CART METHODS ====================

  /// Get current user's cart
  Future<Map<String, dynamic>> getCart() async {
    try {
      print('📤 Getting cart...');

      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: authService.getAuthHeaders(),
      );

      print('📥 Cart response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Cart loaded: ${data['total_items']} items');
        return data;
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      print('❌ Get cart error: $e');
      throw Exception('Failed to load cart: $e');
    }
  }

  /// Add item to cart
  Future<Map<String, dynamic>> addToCart(String productId, int quantity) async {
    try {
      print('📤 Adding to cart: $productId x $quantity');

      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: authService.getAuthHeaders(),
        body: jsonEncode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      print('📥 Add to cart response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Added to cart');
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      print('❌ Add to cart error: $e');
      throw Exception('Failed to add to cart: $e');
    }
  }

  /// Update cart item quantity
  Future<Map<String, dynamic>> updateCartItem(String itemId, int quantity) async {
    try {
      print('📤 Updating cart item: $itemId to quantity $quantity');

      final response = await http.put(
        Uri.parse('$baseUrl/cart/update/$itemId'),
        headers: authService.getAuthHeaders(),
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        print('✅ Cart item updated');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update cart');
      }
    } catch (e) {
      print('❌ Update cart error: $e');
      throw Exception('Failed to update cart: $e');
    }
  }

  /// Remove item from cart
  Future<Map<String, dynamic>> removeFromCart(String itemId) async {
    try {
      print('📤 Removing from cart: $itemId');

      final response = await http.delete(
        Uri.parse('$baseUrl/cart/remove/$itemId'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ Item removed from cart');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to remove from cart');
      }
    } catch (e) {
      print('❌ Remove from cart error: $e');
      throw Exception('Failed to remove from cart: $e');
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    try {
      print('📤 Clearing cart...');

      final response = await http.delete(
        Uri.parse('$baseUrl/cart/clear'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ Cart cleared');
      } else {
        throw Exception('Failed to clear cart');
      }
    } catch (e) {
      print('❌ Clear cart error: $e');
      throw Exception('Failed to clear cart: $e');
    }
  }

  // ==================== WISHLIST METHODS ====================

  /// Get user's wishlist
  /// Get user's wishlist
  Future<List<Product>> getWishlist() async {
    try {
      print('📤 Getting wishlist...');

      final response = await http.get(
        Uri.parse('$baseUrl/wishlist'),
        headers: authService.getAuthHeaders(),
      );

      print('📥 Wishlist response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<dynamic> itemsList;

        if (data is Map<String, dynamic> && data.containsKey('items')) {
          itemsList = data['items'];
        } else if (data is List) {
          itemsList = data;
        } else {
          return [];
        }

        final products = itemsList.map((item) {
          if (item is Map && item.containsKey('product')) {
            return Product.fromJson(item['product']);
          } else {
            return Product.fromJson(item);
          }
        }).toList();

        print('✅ Wishlist loaded: ${products.length} items');
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Failed to load wishlist');
      }
    } catch (e) {
      print('❌ Get wishlist error: $e');
      return [];
    }

  }

  /// Add product to wishlist
  Future<void> addToWishlist(String productId) async {
    try {
      print('📤 Adding to wishlist: $productId');

      final response = await http.post(
        Uri.parse('$baseUrl/wishlist/add'),
        headers: authService.getAuthHeaders(),
        body: jsonEncode({'product_id': productId}),
      );

      if (response.statusCode == 200) {
        print('✅ Added to wishlist');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to add to wishlist');
      }
    } catch (e) {
      print('❌ Add to wishlist error: $e');
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    try {
      print('📤 Removing from wishlist: $productId');

      final response = await http.delete(
        Uri.parse('$baseUrl/wishlist/remove/$productId'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ Removed from wishlist');
      } else {
        throw Exception('Failed to remove from wishlist');
      }
    } catch (e) {
      print('❌ Remove from wishlist error: $e');
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  // ==================== ORDER METHODS ====================

  /// Get user's order history
  Future<List<Map<String, dynamic>>> getOrders({
    String? status,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      print('📤 Getting orders...');

      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };
      if (status != null) queryParams['status'] = status;

      final uri = Uri.parse('$baseUrl/orders').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: authService.getAuthHeaders(),
      );

      print('📥 Orders response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orders = List<Map<String, dynamic>>.from(data['orders']);
        print('✅ Loaded ${orders.length} orders');
        return orders;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('❌ Get orders error: $e');
      throw Exception('Failed to load orders: $e');
    }
  }

  /// Get specific order details
  Future<Map<String, dynamic>> getOrder(String orderId) async {
    try {
      print('📤 Getting order: $orderId');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ Order loaded');
        return jsonDecode(response.body);
      } else {
        throw Exception('Order not found');
      }
    } catch (e) {
      print('❌ Get order error: $e');
      throw Exception('Failed to load order: $e');
    }
  }

  /// Create new order from cart
  Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> deliveryAddress,
    String paymentMethod = 'COD',
  }) async {
    try {
      print('📤 Creating order...');

      final response = await http.post(
        Uri.parse('$baseUrl/orders/create'),
        headers: authService.getAuthHeaders(),
        body: jsonEncode({
          'delivery_address': deliveryAddress,
          'payment_method': paymentMethod,
        }),
      );

      print('📥 Create order response: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Order created: ${data['order']['order_number']}');
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to create order');
      }
    } catch (e) {
      print('❌ Create order error: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  /// Cancel an order
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      print('📤 Cancelling order: $orderId');

      final response = await http.post(
        Uri.parse('$baseUrl/orders/$orderId/cancel'),
        headers: authService.getAuthHeaders(),
        body: jsonEncode({'reason': reason}),
      );

      if (response.statusCode == 200) {
        print('✅ Order cancelled');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to cancel order');
      }
    } catch (e) {
      print('❌ Cancel order error: $e');
      throw Exception('Failed to cancel order: $e');
    }
  }

  // ==================== PROFILE METHODS ====================

  /// Get user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      print('📤 Getting profile...');

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ Profile loaded');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('❌ Get profile error: $e');
      throw Exception('Failed to load profile: $e');
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? email,
  }) async {
    try {
      print('📤 Updating profile...');

      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (email != null) body['email'] = email;

      final response = await http.put(
        Uri.parse('$baseUrl/profile/update'),
        headers: authService.getAuthHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('✅ Profile updated');
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print('❌ Update profile error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Add delivery address
  Future<Map<String, dynamic>> addAddress({
    required String fullName,
    required String phone,
    required String street,
    required String city,
    required String state,
    required String pincode,
    bool isDefault = false,
  }) async {
    try {
      print('📤 Adding address...');

      final response = await http.post(
        Uri.parse('$baseUrl/profile/addresses/add'),
        headers: authService.getAuthHeaders(),
        body: jsonEncode({
          'full_name': fullName,
          'phone': phone,
          'street': street,
          'city': city,
          'state': state,
          'pincode': pincode,
          'is_default': isDefault,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Address added');
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to add address');
      }
    } catch (e) {
      print('❌ Add address error: $e');
      throw Exception('Failed to add address: $e');
    }
  }

  /// Delete delivery address
  Future<void> deleteAddress(String addressId) async {
    try {
      print('📤 Deleting address: $addressId');

      final response = await http.delete(
        Uri.parse('$baseUrl/profile/addresses/$addressId'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ Address deleted');
      } else {
        throw Exception('Failed to delete address');
      }
    } catch (e) {
      print('❌ Delete address error: $e');
      throw Exception('Failed to delete address: $e');
    }
  }

  // ==================== NOTIFICATION METHODS ====================

  /// Get notifications
  Future<List<Map<String, dynamic>>> getNotifications({
    bool unreadOnly = false,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      print('📤 Getting notifications...');

      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
        'unread_only': unreadOnly.toString(),
      };

      final uri = Uri.parse('$baseUrl/notifications').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final notifications = List<Map<String, dynamic>>.from(data['notifications']);
        print('✅ Loaded ${notifications.length} notifications');
        return notifications;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('❌ Get notifications error: $e');
      throw Exception('Failed to load notifications: $e');
    }
  }

  /// Mark notification as read
  Future<void> markNotificationRead(String notificationId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ Notification marked as read');
      } else {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      print('❌ Mark notification error: $e');
      throw Exception('Failed to mark notification: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllNotificationsRead() async {
    try {
      print('📤 Marking all notifications as read...');

      final response = await http.put(
        Uri.parse('$baseUrl/notifications/read-all'),
        headers: authService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        print('✅ All notifications marked as read');
      } else {
        throw Exception('Failed to mark all notifications as read');
      }
    } catch (e) {
      print('❌ Mark all notifications error: $e');
      throw Exception('Failed to mark notifications: $e');
    }
  }
}