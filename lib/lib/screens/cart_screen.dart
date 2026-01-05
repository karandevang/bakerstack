// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cartService = CartService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    await _cartService.fetchCart();
    setState(() => _isLoading = false);
  }

  Future<void> _updateQuantity(int cartItemId, int newQuantity) async {
    final result = await _cartService.updateQuantity(cartItemId, newQuantity);

    if (!result['success'] && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Failed to update quantity'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    setState(() {});
  }

  Future<void> _removeItem(int cartItemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Are you sure you want to remove this item from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _cartService.removeFromCart(cartItemId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Item removed'),
            backgroundColor: result['success'] ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      setState(() {});
    }
  }

  Future<void> _clearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _cartService.clearCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Cart cleared'),
            backgroundColor: result['success'] ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      setState(() {});
    }
  }

  void _proceedToCheckout() {
    Navigator.pushNamed(context, '/checkout');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: const Color(0xFF7B2CBF),
        actions: [
          if (_cartService.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearCart,
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartService.itemCount == 0
          ? _buildEmptyCart()
          : Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadCart,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _cartService.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = _cartService.cartItems[index];
                  return _buildCartItem(cartItem);
                },
              ),
            ),
          ),
          _buildCartSummary(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add some products to get started!',
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

  Widget _buildCartItem(CartItem cartItem) {
    final product = cartItem.product;
    if (product == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        product.formattedPrice,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B2CBF),
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 8),
                        Text(
                          product.formattedMrp,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
                // Remove Button
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => _removeItem(cartItem.id),
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 8),

                // Quantity Selector
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B2CBF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: cartItem.quantity > 1
                            ? () => _updateQuantity(cartItem.id, cartItem.quantity - 1)
                            : null,
                        color: const Color(0xFF7B2CBF),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${cartItem.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: cartItem.quantity < product.stockQuantity
                            ? () => _updateQuantity(cartItem.id, cartItem.quantity + 1)
                            : null,
                        color: const Color(0xFF7B2CBF),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Item Total
                Text(
                  cartItem.formattedTotalPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B2CBF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    return Container(
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
        child: Column(
          children: [
            // Items Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${_cartService.totalQuantity}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Divider(),
            const SizedBox(height: 12),

            // Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${_cartService.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B2CBF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _proceedToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2CBF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'PROCEED TO CHECKOUT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}