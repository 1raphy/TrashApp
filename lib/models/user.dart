class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final double depositBalance;
  final DateTime? emailVerifiedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.depositBalance,
    this.emailVerifiedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      depositBalance: double.parse((json['deposit_balance'] ?? '0').toString()),
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'deposit_balance': depositBalance,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
    };
  }
}
