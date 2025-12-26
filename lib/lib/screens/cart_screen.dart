// lib/screens/cart_screen.dart
// Updated to match the beautiful UI from screenshots

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'wishlist_screen.dart'; // Add this
import 'checkout_screen.dart'; // Add this

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, dynamic>? _cartData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      // TODO: Uncomment when API is ready
      // final cart = await apiService.getCart();

      // Mock data for testing
      await Future.delayed(Duration(seconds: 1));
      final cart = {
        'items': [
          {
            'id': '1',
            'product': {
              'id': '1',
              'name': 'Premium Cake Box - 10 inch White',
              'price': 245.0,
              'image_url': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
            },
            'quantity': 2,
            'subtotal': 490.0,
          },
          {
            'id': '2',
            'product': {
              'id': '2',
              'name': 'Cupcake Boxes - 6 Cavity Clear',
              'price': 180.0,
              'image_url': 'https://images.unsplash.com/photo-1614707267537-b85aaf00c4b7',
            },
            'quantity': 1,
            'subtotal': 180.0,
          },
          {
            'id': '3',
            'product': {
              'id': '3',
              'name': 'Baker\'s Flour - 25kg Premium Grade',
              'price': 1200.0,
              'image_url': 'https://images.unsplash.com/photo-1628568193889-c6a18c6f2b7c',
            },
            'quantity': 1,
            'subtotal': 1200.0,
          },
        ],
        'total_items': 4,
        'total_amount': 1870.0,
      };

      setState(() {
        _cartData = cart;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Cart error: $e');
    }
  }

  Future<void> _updateQuantity(String itemId, int newQuantity) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      // TODO: Uncomment when API is ready
      // await apiService.updateCartItem(itemId, newQuantity);

      // Mock update for testing
      setState(() {
        final items = _cartData!['items'] as List;
        final itemIndex = items.indexWhere((item) => item['id'] == itemId);
        if (itemIndex != -1) {
          items[itemIndex]['quantity'] = newQuantity;
          items[itemIndex]['subtotal'] = items[itemIndex]['product']['price'] * newQuantity;

          // Recalculate totals
          double total = 0;
          int totalItems = 0;
          for (var item in items) {
            total += item['subtotal'];
            totalItems += item['quantity'] as int;
          }
          _cartData!['total_amount'] = total;
          _cartData!['total_items'] = totalItems;
        }
      });

      // await _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update quantity'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeItem(String itemId) async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);

      // TODO: Uncomment when API is ready
      // await apiService.removeFromCart(itemId);

      // Mock remove for testing
      setState(() {
        final items = _cartData!['items'] as List;
        items.removeWhere((item) => item['id'] == itemId);

        // Recalculate totals
        double total = 0;
        int totalItems = 0;
        for (var item in items) {
          total += item['subtotal'];
          totalItems += item['quantity'] as int;
        }
        _cartData!['total_amount'] = total;
        _cartData!['total_items'] = totalItems;
      });

      // await _loadCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item removed from cart'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 70, left: 16, right: 16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove item'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = _cartData != null &&
        _cartData!['items'] != null &&
        (_cartData!['items'] as List).isNotEmpty;

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF667eea),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Wishlist Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.favorite_border, color: Colors.white, size: 20),
                                    Text(
                                      'Wishlist',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  // Navigate to wishlist
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          hasItems
                              ? '${_cartData!['total_items']} items in cart'
                              : 'Your cart is empty',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          _isLoading
              ? SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF667eea)),
            ),
          )
              : !hasItems
              ? SliverFillRemaining(
            child: _buildEmptyState(),
          )
              : SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final items = _cartData!['items'] as List;
                  if (index < items.length) {
                    return _buildCartItem(items[index]);
                  } else if (index == items.length) {
                    return _buildPriceSummary();
                  }
                  return null;
                },
                childCount: (_cartData!['items'] as List).length + 1,
              ),
            ),
          ),
        ],
      ),

      // Checkout Button (if items exist)
      bottomNavigationBar: hasItems
          ? Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '₹${_cartData!['total_amount'] ?? 0}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty Cart Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 24),

          // Empty Message
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),

          Text(
            'Start adding products to your cart',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 32),

          // Shop Now Button
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to home
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              child: Text(
                'Start Shopping',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),

          // View Wishlist Button
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishlistScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              side: BorderSide(color: Color(0xFF667eea), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_outline, color: Color(0xFF667eea)),
                SizedBox(width: 8),
                Text(
                  'View Wishlist',
                  style: TextStyle(
                    color: Color(0xFF667eea),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final product = item['product'];
    final quantity = item['quantity'] ?? 1;
    final subtotal = item['subtotal'] ?? 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              image: product['image_url'] != null && product['image_url'].toString().isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(product['image_url']),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: product['image_url'] == null || product['image_url'].toString().isEmpty
                ? Icon(Icons.image, size: 32, color: Color(0xFF6B7280))
                : null,
          ),
          SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Product',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '₹${product['price'] ?? 0}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF667eea),
                  ),
                ),
                SizedBox(height: 8),

                // Quantity Controls
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 18),
                            onPressed: quantity > 1
                                ? () => _updateQuantity(item['id'], quantity - 1)
                                : null,
                            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '$quantity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 18),
                            onPressed: () => _updateQuantity(item['id'], quantity + 1),
                            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),

                    // Remove Button
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                      onPressed: () => _removeItem(item['id']),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    final totalItems = _cartData!['total_items'] ?? 0;
    final totalAmount = _cartData!['total_amount'] ?? 0.0;

    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items ($totalItems)',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              Text(
                '₹$totalAmount',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                '₹$totalAmount',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF667eea),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}