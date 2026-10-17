class MarketplaceItem {
  final int id;
  final int userId;
  final String equipmentName;
  final String description;
  final String condition;
  final double price;
  final String? imageUrl;
  final String contactPhone;
  final String contactEmail;
  final bool isSold;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarketplaceItem({
    required this.id,
    required this.userId,
    required this.equipmentName,
    required this.description,
    required this.condition,
    required this.price,
    this.imageUrl,
    required this.contactPhone,
    required this.contactEmail,
    this.isSold = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create MarketplaceItem from API JSON response
  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceItem(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      equipmentName: json['equipment_name'] as String,
      description: json['description'] as String,
      condition: json['condition'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      contactPhone: json['contact_phone'] as String,
      contactEmail: json['contact_email'] as String,
      isSold: json['is_sold'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert MarketplaceItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'equipment_name': equipmentName,
      'description': description,
      'condition': condition,
      'price': price,
      'image_url': imageUrl,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'is_sold': isSold,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get formatted price
  String get formattedPrice => '₹${price.toStringAsFixed(2)}';

  /// Get condition badge color
  String get conditionColor {
    switch (condition.toLowerCase()) {
      case 'excellent':
        return 'green';
      case 'good':
        return 'blue';
      case 'fair':
        return 'orange';
      default:
        return 'gray';
    }
  }

  /// Create a copy with updated fields
  MarketplaceItem copyWith({
    int? id,
    int? userId,
    String? equipmentName,
    String? description,
    String? condition,
    double? price,
    String? imageUrl,
    String? contactPhone,
    String? contactEmail,
    bool? isSold,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MarketplaceItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      equipmentName: equipmentName ?? this.equipmentName,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      isSold: isSold ?? this.isSold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
