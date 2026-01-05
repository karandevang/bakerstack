// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _productService = ProductService();
  final _cartService = CartService();
  final _wishlistService = WishlistService();

  Product? _product;
  bool _isLoading = true;
  bool _isInWishlist = false;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() => _isLoading = true);

    final product = await _productService.getProductById(widget.productId);

    setState(() {
      _product = product;
      _isInWishlist = product != null && _wishlistService.isInWishlist(product.id);
      _isLoading = false;
    });
  }

  Future<void> _addToCart() async {
    if (_product == null) return;

    final result = await _cartService.addToCart(_product!.id, quantity: _quantity);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['success']
                ? 'Added $_quantity x ${_product!.name} to cart'
                : result['error'] ?? 'Failed to add to cart',
          ),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (result['success']) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _toggleWishlist() async {
    if (_product == null) return;

    Map<String, dynamic> result;
    if (_isInWishlist) {
      final wishlistItems = await _wishlistService.fetchWishlist();
      final item = wishlistItems.firstWhere((item) => item.id == _product!.id);
      result = await _wishlistService.removeFromWishlist(item.id);
    } else {
      result = await _wishlistService.addToWishlist(_product!.id);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Wishlist updated'),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (result['success']) {
        setState(() => _isInWishlist = !_isInWishlist);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _product == null
          ? _buildErrorState()
          : _buildProductDetail(),
    );
  }

  Widget _buildProductDetail() {
    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: const Color(0xFF7B2CBF),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                // Discount Badge
                if (_product!.isOnSale)
                  Positioned(
                    top: 60,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '-${_product!.discountPercent}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isInWishlist ? Icons.favorite : Icons.favorite_border,
                color: _isInWishlist ? Colors.red : Colors.white,
              ),
              onPressed: _toggleWishlist,
            ),
          ],
        ),

        // Product Details
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B2CBF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _product!.category,
                      style: const TextStyle(
                        color: Color(0xFF7B2CBF),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Product Name
                  Text(
                    _product!.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    children: [
                      Text(
                        _product!.formattedPrice,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B2CBF),
                        ),
                      ),
                      if (_product!.isOnSale) ...[
                        const SizedBox(width: 12),
                        Text(
                          _product!.formattedMrp,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stock Status
                  Row(
                    children: [
                      Icon(
                        _product!.inStock ? Icons.check_circle : Icons.cancel,
                        color: _product!.inStock ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _product!.inStock
                            ? 'In Stock (${_product!.stockQuantity} available)'
                            : 'Out of Stock',
                        style: TextStyle(
                          color: _product!.inStock ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  if (_product!.inStock) ...[
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          },
                        ),
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            '$_quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildQuantityButton(
                          icon: Icons.add,
                          onTap: () {
                            if (_quantity < _product!.stockQuantity) {
                              setState(() => _quantity++);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _product!.description ?? 'No description available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF7B2CBF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF7B2CBF).withOpacity(0.3),
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF7B2CBF),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Product not found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    if (_product == null || !_product!.inStock) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B2CBF),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}