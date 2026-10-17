// lib/services/product_service.dart
/// Product Service for BakerStack
///
/// Handles all product-related API calls including
/// fetching products, categories, search, and filters.

import '../models/product.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final ApiService _api = ApiService();

  /// Get all products
  Future<List<Product>> getProducts({
    String? category,
    String? search,
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      // Build query parameters
      String endpoint = ApiConfig.products;
      List<String> params = [];

      if (category != null && category.isNotEmpty) {
        params.add('category=$category');
      }
      if (search != null && search.isNotEmpty) {
        params.add('search=$search');
      }
      params.add('skip=$skip');
      params.add('limit=$limit');

      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }

      print('🛍️ Fetching products: $endpoint');

      final response = await _api.get(endpoint);

      if (response['success']) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        print('❌ Failed to fetch products: ${response['error']}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching products: $e');
      return [];
    }
  }

  /// Get product by ID
  Future<Product?> getProductById(int id) async {
    try {
      print('🛍️ Fetching product: $id');

      final response = await _api.get('${ApiConfig.products}/$id');

      if (response['success']) {
        return Product.fromJson(response['data']);
      } else {
        print('❌ Failed to fetch product: ${response['error']}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching product: $e');
      return null;
    }
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    return getProducts(category: category);
  }

  /// Search products
  Future<List<Product>> searchProducts(String query) async {
    return getProducts(search: query);
  }

  /// Get all available categories
  Future<List<String>> getCategories() async {
    try {
      // Fetch all products and extract unique categories
      final products = await getProducts();
      final categories = products.map((p) => p.category).toSet().toList();
      categories.sort();
      return categories;
    } catch (e) {
      print('❌ Error fetching categories: $e');
      return [];
    }
  }

  /// Get featured products (in stock and on sale)
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final products = await getProducts();
      return products.where((p) => p.inStock && p.isOnSale).toList();
    } catch (e) {
      print('❌ Error fetching featured products: $e');
      return [];
    }
  }

  /// Get products on sale
  Future<List<Product>> getProductsOnSale() async {
    try {
      final products = await getProducts();
      return products.where((p) => p.isOnSale).toList();
    } catch (e) {
      print('❌ Error fetching sale products: $e');
      return [];
    }
  }

  /// Get products in stock
  Future<List<Product>> getProductsInStock() async {
    try {
      final products = await getProducts();
      return products.where((p) => p.inStock).toList();
    } catch (e) {
      print('❌ Error fetching in-stock products: $e');
      return [];
    }
  }

  /// Filter products by price range
  List<Product> filterByPriceRange(
      List<Product> products,
      double minPrice,
      double maxPrice,
      ) {
    return products
        .where((p) => p.price >= minPrice && p.price <= maxPrice)
        .toList();
  }

  /// Sort products
  List<Product> sortProducts(List<Product> products, String sortBy) {
    final sorted = List<Product>.from(products);

    switch (sortBy) {
      case 'price_low_high':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high_low':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'discount':
        sorted.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
        break;
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'newest':
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      default:
      // Keep original order
        break;
    }

    return sorted;
  }
}
