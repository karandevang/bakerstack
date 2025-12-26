// lib/screens/wishlist_screen.dart
// View and manage favorited/saved products

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isLoading = true;
  List<Product> _wishlistItems = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: Replace with actual API call
      // final items = await apiService.getWishlist();

      // Mock data for now
      await Future.delayed(Duration(seconds: 1));
      _wishlistItems = [
        Product(
          id: '1',
          name: 'Premium Cake Box - 10 inch White',
          price: 245.0,
          mrp: 350.0,
          description: 'Premium Cake Box - 10 inch White',
          discountPercent: 30,
          imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
          category: 'Boxes',
          inStock: true,
        ),
        Product(
          id: '2',
          name: 'Cupcake Boxes - 6 Cavity Clear',
          price: 180.0,
          mrp: 250.0,
          description: 'Premium Cake Box - 10 inch White',
          discountPercent: 28,
          imageUrl: 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7',
          category: 'Boxes',
          inStock: true,
        ),
        Product(
          id: '3',
          name: 'Baker\'s Flour - 25kg Premium Grade',
          price: 1200.0,
          mrp: 1500.0,
          description: 'Premium Cake Box - 10 inch White',
          discountPercent: 20,
          imageUrl: 'https://images.unsplash.com/photo-1628568193889-c6a18c6f2b7c',
          category: 'Ingredients',
          inStock: false,
        ),
      ];

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load wishlist'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B73FF), Color(0xFF9F7FFF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Wishlist',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_wishlistItems.length} items saved',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6B73FF),
              ),
            )
                : _wishlistItems.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadWishlist,
              color: Color(0xFF6B73FF),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _wishlistItems.length,
                itemBuilder: (context, index) {
                  return _buildWishlistCard(_wishlistItems[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistCard(Product item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: item),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xFFF0F0F0),
                  image: item.imageUrl != null
                      ? DecorationImage(
                    image: NetworkImage(item.imageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: Stack(
                  children: [
                    // Discount Badge
                    if (item.discountPercent > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${item.discountPercent}% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF6B73FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          color: Color(0xFF6B73FF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),

                    // Product Name
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),

                    // Price
                    Row(
                      children: [
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B73FF),
                          ),
                        ),
                        SizedBox(width: 8),
                        if (item.mrp > item.price)
                          Text(
                            '₹${item.mrp.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF999999),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 6),

                    // Stock Status
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: item.inStock ? Color(0xFF10B981) : Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          item.inStock ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 12,
                            color: item.inStock ? Color(0xFF10B981) : Color(0xFFEF4444),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions Column
              Column(
                children: [
                  // Remove from Wishlist
                  IconButton(
                    onPressed: () => _removeFromWishlist(item),
                    icon: Icon(Icons.favorite, color: Color(0xFFEF4444)),
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFFEF4444).withOpacity(0.1),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Add to Cart
                  if (item.inStock)
                    IconButton(
                      onPressed: () => _addToCart(item),
                      icon: Icon(Icons.shopping_cart_outlined, color: Color(0xFF6B73FF)),
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF6B73FF).withOpacity(0.1),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 100,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 24),
          Text(
            'Your Wishlist is Empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Save items you love by tapping the\nheart icon on products',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B73FF),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Start Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeFromWishlist(Product item) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove from Wishlist?'),
        content: Text('Do you want to remove "${item.name}" from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final apiService = Provider.of<ApiService>(context, listen: false);
        // TODO: API call to remove from wishlist
        // await apiService.removeFromWishlist(item.id);

        setState(() {
          _wishlistItems.remove(item);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from wishlist'),
            backgroundColor: Color(0xFF6B7280),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove item'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _addToCart(Product item) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      // TODO: API call to add to cart
      // await apiService.addToCart(item.id, 1);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(child: Text('Added to cart!')),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }
}