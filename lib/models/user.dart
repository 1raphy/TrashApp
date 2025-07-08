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
    try {
      print('Parsing User JSON: $json'); // Log untuk debugging
      return User(
        id: int.parse(json['id']?.toString() ?? '0'),
        name: json['name']?.toString() ?? 'Unknown',
        email: json['email']?.toString() ?? 'Unknown',
        phone: json['phone']?.toString(),
        role: json['role']?.toString() ?? 'nasabah',
        depositBalance:
            double.tryParse(json['deposit_balance']?.toString() ?? '0.0') ??
            0.0,
        emailVerifiedAt: json['email_verified_at'] != null
            ? DateTime.tryParse(json['email_verified_at']?.toString() ?? '')
            : null,
      );
    } catch (e) {
      print('Error parsing User: $e, JSON: $json');
      rethrow;
    }
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
