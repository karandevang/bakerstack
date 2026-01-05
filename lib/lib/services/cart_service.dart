// lib/services/cart_service.dart
/// Cart Service for BakerStack
///
/// Handles all shopping cart operations including
/// adding items, updating quantities, and removing items.

import '../models/cart_item.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final ApiService _api = ApiService();
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;

  /// Calculate total price
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Calculate total items (with quantities)
  int get totalQuantity {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get user's cart
  Future<bool> fetchCart() async {
    try {
      print('🛒 Fetching cart...');

      final response = await _api.get(ApiConfig.cart, auth: true);

      if (response['success']) {
        final List<dynamic> data = response['data'];
        _cartItems = data.map((json) => CartItem.fromJson(json)).toList();
        print('✅ Cart loaded: ${_cartItems.length} items');
        return true;
      } else {
        print('❌ Failed to fetch cart: ${response['error']}');
        return false;
      }
    } catch (e) {
      print('❌ Error fetching cart: $e');
      return false;
    }
  }

  /// Add item to cart
  Future<Map<String, dynamic>> addToCart(int productId, {int quantity = 1}) async {
    try {
      print('🛒 Adding to cart: Product $productId (qty: $quantity)');

      final response = await _api.post(
        ApiConfig.cartAdd,
        {
          'product_id': productId,
          'quantity': quantity,
        },
        auth: true,
      );

      if (response['success']) {
        // Refresh cart
        await fetchCart();
        return {
          'success': true,
          'message': 'Added to cart successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to add to cart',
        };
      }
    } catch (e) {
      print('❌ Error adding to cart: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Update cart item quantity
  Future<Map<String, dynamic>> updateQuantity(int cartItemId, int quantity) async {
    try {
      print('🛒 Updating cart item $cartItemId to quantity: $quantity');

      if (quantity <= 0) {
        return removeFromCart(cartItemId);
      }

      final response = await _api.put(
        ApiConfig.cartUpdate,
        {
          'cart_item_id': cartItemId,
          'quantity': quantity,
        },
        auth: true,
      );

      if (response['success']) {
        // Refresh cart
        await fetchCart();
        return {
          'success': true,
          'message': 'Cart updated successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to update cart',
        };
      }
    } catch (e) {
      print('❌ Error updating cart: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Remove item from cart
  Future<Map<String, dynamic>> removeFromCart(int cartItemId) async {
    try {
      print('🛒 Removing from cart: Item $cartItemId');

      final response = await _api.delete(
        '${ApiConfig.cart}/$cartItemId',
        auth: true,
      );

      if (response['success']) {
        // Refresh cart
        await fetchCart();
        return {
          'success': true,
          'message': 'Removed from cart successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to remove from cart',
        };
      }
    } catch (e) {
      print('❌ Error removing from cart: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Clear entire cart
  Future<Map<String, dynamic>> clearCart() async {
    try {
      print('🛒 Clearing cart...');

      final response = await _api.delete(ApiConfig.cartClear, auth: true);

      if (response['success']) {
        _cartItems.clear();
        return {
          'success': true,
          'message': 'Cart cleared successfully',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to clear cart',
        };
      }
    } catch (e) {
      print('❌ Error clearing cart: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Check if product is in cart
  bool isInCart(int productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  /// Get cart item by product ID
  CartItem? getCartItemByProductId(int productId) {
    try {
      return _cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Increment quantity
  Future<Map<String, dynamic>> incrementQuantity(int cartItemId) async {
    final item = _cartItems.firstWhere((item) => item.id == cartItemId);
    return updateQuantity(cartItemId, item.quantity + 1);
  }

  /// Decrement quantity
  Future<Map<String, dynamic>> decrementQuantity(int cartItemId) async {
    final item = _cartItems.firstWhere((item) => item.id == cartItemId);
    if (item.quantity > 1) {
      return updateQuantity(cartItemId, item.quantity - 1);
    } else {
      return removeFromCart(cartItemId);
    }
  }
}
