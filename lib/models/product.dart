class Product {
  final int id; // Integer ID from backend
  final String name;
  final String? description;
  final String category;
  final double price;
  final double mrp;
  final int discountPercent;
  final String? imageUrl;
  final bool inStock;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.price,
    required this.mrp,
    this.discountPercent = 0,
    this.imageUrl,
    this.inStock = true,
    this.stockQuantity = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Product from API JSON response
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      mrp: (json['mrp'] as num).toDouble(),
      discountPercent: json['discount_percent'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      inStock: json['in_stock'] as bool? ?? true,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'mrp': mrp,
      'discount_percent': discountPercent,
      'image_url': imageUrl,
      'in_stock': inStock,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Calculated discount amount
  double get discountAmount => mrp - price;

  /// Check if product is on sale
  bool get isOnSale => discountPercent > 0;

  /// Get formatted price
  String get formattedPrice => '₹${price.toStringAsFixed(2)}';

  /// Get formatted MRP
  String get formattedMrp => '₹${mrp.toStringAsFixed(2)}';

  /// Create a copy with updated fields
  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    double? price,
    double? mrp,
    int? discountPercent,
    String? imageUrl,
    bool? inStock,
    int? stockQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      discountPercent: discountPercent ?? this.discountPercent,
      imageUrl: imageUrl ?? this.imageUrl,
      inStock: inStock ?? this.inStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
