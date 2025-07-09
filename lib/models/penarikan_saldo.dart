class PenarikanSaldo {
  final int id;
  final int userId;
  final double jumlah;
  final DateTime createdAt;
  final DateTime updatedAt;

  PenarikanSaldo({
    required this.id,
    required this.userId,
    required this.jumlah,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PenarikanSaldo.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing PenarikanSaldo JSON: $json'); // Log untuk debugging
      return PenarikanSaldo(
        id: int.parse(json['id']?.toString() ?? '0'),
        userId: int.parse(json['user_id']?.toString() ?? '0'),
        jumlah: double.tryParse(json['jumlah']?.toString() ?? '0.0') ?? 0.0,
        createdAt:
            DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt:
            DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
            DateTime.now(),
      );
    } catch (e) {
      print('Error parsing PenarikanSaldo: $e, JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'jumlah': jumlah,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
