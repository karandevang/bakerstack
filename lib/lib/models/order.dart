import 'package:bakerstack/models/product.dart';

class Order {
  final int id;
  final int userId;
  final double totalAmount;
  final String status;
  final int? addressId;
  final String? notes;
  final List<OrderItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    this.addressId,
    this.notes,
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Order from API JSON response
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      addressId: json['address_id'] as int?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert Order to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'address_id': addressId,
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get formatted total amount
  String get formattedTotal => '₹${totalAmount.toStringAsFixed(2)}';

  /// Get status color
  String getStatusColor() {
    switch (status.toLowerCase()) {
      case 'processing':
        return 'blue';
      case 'shipped':
        return 'orange';
      case 'delivered':
        return 'green';
      case 'cancelled':
        return 'red';
      default:
        return 'gray';
    }
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;
  final Product? product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.product,
  });

  /// Create OrderItem from API JSON response
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert OrderItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      if (product != null) 'product': product!.toJson(),
    };
  }

  /// Calculate total for this order item
  double get totalPrice => price * quantity;
}
