// lib/screens/product_detail_screen.dart
// CORRECT VERSION - Works with Product model

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product; // ✅ Using Product model, not Map

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isLoading = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: _isFavorite ? Color(0xFFEF4444) : Color(0xFF1A1A1A),
                      ),
                      onPressed: () {
                        setState(() => _isFavorite = !_isFavorite);
                        // TODO: Add to wishlist API call
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Color(0xFFF5F5F5),
                    child: product.imageUrl != null
                        ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 100,
                            color: Color(0xFFCCCCCC),
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 100,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                ),
              ),

              // Product Details
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF6B73FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              color: Color(0xFF6B73FF),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Product Name
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Price Section
                        Row(
                          children: [
                            Text(
                              '₹${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B73FF),
                              ),
                            ),
                            SizedBox(width: 12),
                            if (product.mrp > product.price) ...[
                              Text(
                                '₹${product.mrp.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF999999),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${product.discountPercent}% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 20),

                        // Stock Status
                        Row(
                          children: [
                            Icon(
                              product.inStock ? Icons.check_circle : Icons.cancel,
                              color: product.inStock ? Color(0xFF10B981) : Color(0xFFEF4444),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              product.inStock ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: product.inStock ? Color(0xFF10B981) : Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Divider
                        Divider(color: Color(0xFFE5E7EB)),
                        SizedBox(height: 24),

                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          product.description ?? 'No description available',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Divider
                        Divider(color: Color(0xFFE5E7EB)),
                        SizedBox(height: 24),

                        // Quantity Selector
                        Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildQuantitySelector(),
                        SizedBox(height: 100), // Space for bottom buttons
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16,8,16,12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Buy Now Button (Outlined)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: product.inStock ? () => _handleBuyNow() : null,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: product.inStock ? Color(0xFF6B73FF) : Color(0xFFCCCCCC),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: product.inStock ? Color(0xFF6B73FF) : Color(0xFFCCCCCC),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // Add to Cart Button (Filled)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: product.inStock ? () => _addToCart() : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: product.inStock ? Color(0xFF6B73FF) : Color(0xFFCCCCCC),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus Button
          IconButton(
            onPressed: _quantity > 1
                ? () {
              setState(() => _quantity--);
            }
                : null,
            icon: Icon(
              Icons.remove,
              color: _quantity > 1 ? Color(0xFF6B73FF) : Color(0xFFCCCCCC),
            ),
          ),

          // Quantity Display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              _quantity.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),

          // Plus Button
          IconButton(
            onPressed: () {
              setState(() => _quantity++);
            },
            icon: Icon(
              Icons.add,
              color: Color(0xFF6B73FF),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      await apiService.addToCart(widget.product.id, _quantity); // ✅ Using product.id

      setState(() => _isLoading = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Added to cart successfully!',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Reset quantity
      setState(() => _quantity = 1);
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: ${e.toString()}'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _handleBuyNow() {
    // Add to cart and navigate to cart screen
    _addToCart().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Proceeding to checkout...'),
          backgroundColor: Color(0xFF6B73FF),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    });
  }
}