class JenisSampah {
  final int id;
  final String namaSampah;
  final double hargaPerKg;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JenisSampah({
    required this.id,
    required this.namaSampah,
    required this.hargaPerKg,
    this.createdAt,
    this.updatedAt,
  });

  factory JenisSampah.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing JenisSampah JSON: $json'); // Log untuk debugging
      return JenisSampah(
        id: int.parse(json['id']?.toString() ?? '0'),
        namaSampah: json['nama_sampah']?.toString() ?? 'Unknown',
        hargaPerKg:
            double.tryParse(json['harga_per_kg']?.toString() ?? '0.0') ?? 0.0,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at']?.toString() ?? '')
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at']?.toString() ?? '')
            : null,
      );
    } catch (e) {
      print('Error parsing JenisSampah: $e, JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_sampah': namaSampah,
      'harga_per_kg': hargaPerKg,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// class JenisSampah {
//   final int id;
//   final String namaSampah;
//   final double hargaPerKg;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   JenisSampah({
//     required this.id,
//     required this.namaSampah,
//     required this.hargaPerKg,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory JenisSampah.fromJson(Map<String, dynamic> json) {
//     return JenisSampah(
//       id: json['id'],
//       namaSampah: json['nama_sampah'],
//       hargaPerKg: double.parse(json['harga_per_kg'].toString()),
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'nama_sampah': namaSampah, 'harga_per_kg': hargaPerKg};
//   }
// }
