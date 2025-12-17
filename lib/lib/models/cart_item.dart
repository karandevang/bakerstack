// lib/models/cart_item.dart - Final Comprehensive Version

import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final double subtotal;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.subtotal,
  });

  /// Create CartItem from API JSON response
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? '',
      product: Product.fromJson(json['product']),
      quantity: _parseInt(json['quantity']),
      subtotal: _parseDouble(json['subtotal']),
    );
  }

  /// Convert CartItem to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  // ==================== HELPER PARSING METHODS ====================

  /// Safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Safely parse int values
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // ==================== COMPUTED PROPERTIES ====================

  /// Calculate total savings for this cart item
  double get savings => (product.mrp - product.price) * quantity;

  /// Get formatted subtotal string
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(0)}';

  /// Get formatted savings string
  String get formattedSavings => '₹${savings.toStringAsFixed(0)}';

  /// Get formatted unit price
  String get formattedUnitPrice => product.price.toStringAsFixed(0);

  // ==================== UTILITY METHODS ====================

  /// Copy with method for easy updates
  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    double? subtotal,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  /// String representation for debugging
  @override
  String toString() {
    return 'CartItem(id: $id, product: ${product.name}, quantity: $quantity, subtotal: $subtotal)';
  }

  /// Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  /// Hash code
  @override
  int get hashCode => id.hashCode;
}