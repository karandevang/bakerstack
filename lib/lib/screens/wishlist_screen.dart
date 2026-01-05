// lib/screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import '../services/wishlist_service.dart';
import '../services/cart_service.dart';
import '../models/product.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _wishlistService = WishlistService();
  final _cartService = CartService();

  List<Product> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);

    final items = await _wishlistService.fetchWishlist();

    setState(() {
      _wishlistItems = items;
      _isLoading = false;
    });
  }

  Future<void> _removeFromWishlist(Product product) async {
    // Find the wishlist item ID
    final wishlistItems = await _wishlistService.fetchWishlist();
    final item = wishlistItems.firstWhere((item) => item.id == product.id);

    final result = await _wishlistService.removeFromWishlist(item.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Removed from wishlist'),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (result['success']) {
        _loadWishlist();
      }
    }
  }

  Future<void> _addToCart(Product product) async {
    final result = await _cartService.addToCart(product.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['success']
                ? '${product.name} added to cart!'
                : result['error'] ?? 'Failed to add to cart',
          ),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _moveToCart(Product product) async {
    // Add to cart
    final addResult = await _cartService.addToCart(product.id);

    if (addResult['success']) {
      // Remove from wishlist
      await _removeFromWishlist(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} moved to cart!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: const Color(0xFF7B2CBF),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wishlistItems.isEmpty
          ? _buildEmptyWishlist()
          : RefreshIndicator(
        onRefresh: _loadWishlist,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _wishlistItems.length,
          itemBuilder: (context, index) {
            final product = _wishlistItems[index];
            return _buildWishlistItem(product);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Save items you like to your wishlist!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Browse Products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B2CBF),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              // Discount Badge
              if (product.isOnSale)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '-${product.discountPercent}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Remove Button
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () => _removeFromWishlist(product),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Product Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),

                  // Price
                  Row(
                    children: [
                      Text(
                        product.formattedPrice,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B2CBF),
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 6),
                        Text(
                          product.formattedMrp,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Move to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: product.inStock
                          ? () => _moveToCart(product)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B2CBF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        product.inStock ? 'Move to Cart' : 'Out of Stock',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}