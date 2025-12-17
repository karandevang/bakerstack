class User {
  final int id;
  final String phoneNumber;
  final String? fullName;
  final String? email;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.phoneNumber,
    this.fullName,
    this.email,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phone_number'],
      fullName: json['full_name'],
      email: json['email'],
      isActive: json['is_active'],
      isVerified: json['is_verified'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'email': email,
      'is_active': isActive,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }
}