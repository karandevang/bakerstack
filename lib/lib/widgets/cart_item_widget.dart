// lib/widgets/cart_item_widget.dart
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback? onRemove;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    this.onRemove,
    this.onIncrement,
    this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  onPressed: onRemove,
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
                        onPressed: cartItem.quantity > 1 ? onDecrement : null,
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
                            ? onIncrement
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
}