import 'package:trasav/models/setoran_sampah.dart';
import 'package:trasav/models/penarikan_saldo.dart';
import 'package:trasav/models/user.dart';

class NotificationModel {
  final int id;
  final int userId;
  final String type;
  final String message;
  final String status;
  final int? setoranSampahId;
  final int? penarikanSaldoId;
  final DateTime createdAt; // Ubah dari String ke DateTime
  final DateTime updatedAt;
  final User? user;
  final SetoranSampah? setoranSampah;
  final PenarikanSaldo? penarikanSaldo;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.status,
    this.setoranSampahId,
    this.penarikanSaldoId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.setoranSampah,
    this.penarikanSaldo,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      message: json['message'],
      status: json['status'],
      setoranSampahId: json['setoran_sampah_id'],
      penarikanSaldoId: json['penarikan_saldo_id'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ), // Parsing String ke DateTime
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      setoranSampah: json['setoran_sampah'] != null
          ? SetoranSampah.fromJson(json['setoran_sampah'])
          : null,
      penarikanSaldo: json['penarikan_saldo'] != null
          ? PenarikanSaldo.fromJson(json['penarikan_saldo'])
          : null,
    );
  }
}
