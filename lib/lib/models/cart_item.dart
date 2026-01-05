import 'package:bakerstack/models/product.dart';

class CartItem {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final Product? product; // Nested product object from backend
  final DateTime createdAt;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.product,
    required this.createdAt,
  });

  /// Create CartItem from API JSON response
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      if (product != null) 'product': product!.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Calculate total price for this cart item
  double get totalPrice {
    if (product == null) return 0.0;
    return product!.price * quantity;
  }

  /// Get formatted total price
  String get formattedTotalPrice => '₹${totalPrice.toStringAsFixed(2)}';

  /// Create a copy with updated fields
  CartItem copyWith({
    int? id,
    int? userId,
    int? productId,
    int? quantity,
    Product? product,
    DateTime? createdAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}