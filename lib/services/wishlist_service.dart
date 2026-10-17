import '../models/product.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final ApiService _api = ApiService();
  List<int> _wishlistProductIds = [];

  List<int> get wishlistProductIds => _wishlistProductIds;

  /// Fetch user's wishlist
  Future<List<Product>> fetchWishlist() async {
    try {
      print('❤️ Fetching wishlist...');

      final response = await _api.get(ApiConfig.wishlist, auth: true);

      if (response['success']) {
        final List<dynamic> data = response['data'];
        final products = <Product>[];
        _wishlistProductIds.clear();

        for (var item in data) {
          if (item['product'] != null) {
            final product = Product.fromJson(item['product']);
            products.add(product);
            _wishlistProductIds.add(product.id);
          }
        }

        print('✅ Wishlist loaded: ${products.length} items');
        return products;
      } else {
        print('❌ Failed to fetch wishlist: ${response['error']}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching wishlist: $e');
      return [];
    }
  }

  /// Add product to wishlist
  Future<Map<String, dynamic>> addToWishlist(int productId) async {
    try {
      print('❤️ Adding to wishlist: Product $productId');

      final response = await _api.post(
        ApiConfig.wishlistAdd,
        {'product_id': productId},
        auth: true,
      );

      if (response['success']) {
        _wishlistProductIds.add(productId);
        return {
          'success': true,
          'message': 'Added to wishlist',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to add to wishlist',
        };
      }
    } catch (e) {
      print('❌ Error adding to wishlist: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Remove product from wishlist
  Future<Map<String, dynamic>> removeFromWishlist(int wishlistItemId) async {
    try {
      print('❤️ Removing from wishlist: Item $wishlistItemId');

      final response = await _api.delete(
        '${ApiConfig.wishlist}/$wishlistItemId',
        auth: true,
      );

      if (response['success']) {
        return {
          'success': true,
          'message': 'Removed from wishlist',
        };
      } else {
        return {
          'success': false,
          'error': response['error'] ?? 'Failed to remove from wishlist',
        };
      }
    } catch (e) {
      print('❌ Error removing from wishlist: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Check if product is in wishlist
  bool isInWishlist(int productId) {
    return _wishlistProductIds.contains(productId);
  }

  /// Toggle wishlist status
  Future<Map<String, dynamic>> toggleWishlist(int productId, int? wishlistItemId) async {
    if (isInWishlist(productId) && wishlistItemId != null) {
      return removeFromWishlist(wishlistItemId);
    } else {
      return addToWishlist(productId);
    }
  }
}
