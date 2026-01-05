// lib/models/user.dart
class User {
  final int id;
  final String fullName;
  final String phone;
  final String email;
  final DateTime createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      fullName: json['full_name'] as String? ?? json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}