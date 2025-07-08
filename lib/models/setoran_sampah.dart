import 'package:trasav/models/jenis_sampah.dart';
import 'package:trasav/models/user.dart';

class SetoranSampah {
  final int id;
  final int userId;
  final int jenisSampahId;
  final double beratKg;
  final double totalHarga;
  final String metodePenjemputan;
  final String? alamatPenjemputan;
  final String? catatanTambahan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final JenisSampah? jenisSampah;

  SetoranSampah({
    required this.id,
    required this.userId,
    required this.jenisSampahId,
    required this.beratKg,
    required this.totalHarga,
    required this.metodePenjemputan,
    this.alamatPenjemputan,
    this.catatanTambahan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.jenisSampah,
  });

  factory SetoranSampah.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing SetoranSampah JSON: $json'); // Log untuk debugging
      return SetoranSampah(
        id: int.parse(json['id']?.toString() ?? '0'),
        userId: int.parse(json['user_id']?.toString() ?? '0'),
        jenisSampahId: int.parse(json['jenis_sampah_id']?.toString() ?? '0'),
        beratKg: double.tryParse(json['berat_kg']?.toString() ?? '0.0') ?? 0.0,
        totalHarga:
            double.tryParse(json['total_harga']?.toString() ?? '0.0') ?? 0.0,
        metodePenjemputan: json['metode_penjemputan']?.toString() ?? 'Unknown',
        alamatPenjemputan: json['alamat_penjemputan']?.toString(),
        catatanTambahan: json['catatan_tambahan']?.toString(),
        status: json['status']?.toString() ?? 'Unknown',
        createdAt:
            DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
        updatedAt:
            DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
            DateTime.now(),
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        jenisSampah: json['jenis_sampah'] != null
            ? JenisSampah.fromJson(json['jenis_sampah'])
            : null,
      );
    } catch (e) {
      print('Error parsing SetoranSampah: $e, JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'jenis_sampah_id': jenisSampahId,
      'berat_kg': beratKg,
      'total_harga': totalHarga,
      'metode_penjemputan': metodePenjemputan,
      'alamat_penjemputan': alamatPenjemputan,
      'catatan_tambahan': catatanTambahan,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'jenis_sampah': jenisSampah?.toJson(),
    };
  }
}

// class JenisSampah {
//   final int id;
//   final String namaSampah;
//   final double hargaPerKg;

//   JenisSampah({
//     required this.id,
//     required this.namaSampah,
//     required this.hargaPerKg,
//   });

//   factory JenisSampah.fromJson(Map<String, dynamic> json) {
//     try {
//       return JenisSampah(
//         id: int.parse(json['id']?.toString() ?? '0'),
//         namaSampah: json['nama_sampah']?.toString() ?? 'Unknown',
//         hargaPerKg:
//             double.tryParse(json['harga_per_kg']?.toString() ?? '0.0') ?? 0.0,
//       );
//     } catch (e) {
//       print('Error parsing JenisSampah: $e, JSON: $json');
//       rethrow;
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {'id': id, 'nama_sampah': namaSampah, 'harga_per_kg': hargaPerKg};
//   }
// }

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
