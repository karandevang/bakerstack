// lib/models/product.dart - COMPLETE VERSION

class Product {
  // All fields
  final String id;
  final String name;
  final String description;
  final double price;
  final double mrp;
  final int discountPercent;      // ✅ ADDED
  final String imageUrl;
  final String category;
  final bool inStock;             // ✅ ADDED
  final int stockQuantity;        // ✅ ADDED

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.discountPercent,  // ✅ ADDED
    required this.imageUrl,
    required this.category,
    this.inStock = true,            // ✅ ADDED
    this.stockQuantity = 0,         // ✅ ADDED
  });

  // ✅ ADDED: Create Product from API JSON response
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
      description: _parseString(json['description']),
      price: _parseDouble(json['price']),
      mrp: _parseDouble(json['mrp']),
      discountPercent: _parseInt(json['discount_percent']),
      imageUrl: _parseString(json['image_url']),
      category: _parseString(json['category']),
      inStock: json['in_stock'] ?? true,
      stockQuantity: _parseInt(json['stock_quantity']),
    );
  }

  // ✅ ADDED: Convert Product to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'mrp': mrp,
      'discount_percent': discountPercent,
      'image_url': imageUrl,
      'category': category,
      'in_stock': inStock,
      'stock_quantity': stockQuantity,
    };
  }

  // ✅ ADDED: Helper methods for safe parsing
  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // ✅ ADDED: Computed properties
  double get savings => mrp - price;
  bool get isAvailable => inStock && stockQuantity > 0;
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get formattedMrp => '₹${mrp.toStringAsFixed(0)}';
  String get formattedDiscount => '${discountPercent}% OFF';
  String get formattedSavings => '₹${savings.toStringAsFixed(0)}';

  // ✅ ADDED: Utility methods
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? mrp,
    int? discountPercent,
    String? imageUrl,
    String? category,
    bool? inStock,
    int? stockQuantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      discountPercent: discountPercent ?? this.discountPercent,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      inStock: inStock ?? this.inStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}