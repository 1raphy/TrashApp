import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jenis_sampah.dart';

class JenisSampahService {
  final String baseUrl =
      'http://10.0.2.2:8000/api'; // Ganti dengan URL API Anda
  final String token;

  JenisSampahService({required this.token});

  // Mendapatkan semua jenis sampah
  Future<List<JenisSampah>> getJenisSampah() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/jenis-sampah-index'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return (data['data'] as List)
              .map((item) => JenisSampah.fromJson(item))
              .toList();
        } else {
          throw Exception(
            'Gagal mengambil data: ${data['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception('Gagal mengambil data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Menambahkan jenis sampah
  Future<JenisSampah> createJenisSampah(JenisSampah jenisSampah) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jenis-sampah'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(jenisSampah.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return JenisSampah.fromJson(data['data']);
        } else {
          throw Exception(
            'Gagal menambahkan jenis sampah: ${data['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception(
          'Gagal menambahkan jenis sampah: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Memperbarui jenis sampah
  Future<JenisSampah> updateJenisSampah(int id, JenisSampah jenisSampah) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/jenis-sampah/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(jenisSampah.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return JenisSampah.fromJson(data['data']);
        } else {
          throw Exception(
            'Gagal memperbarui jenis sampah: ${data['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception(
          'Gagal memperbarui jenis sampah: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Menghapus jenis sampah
  Future<void> deleteJenisSampah(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/jenis-sampah/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] != 'success') {
          throw Exception(
            'Gagal menghapus jenis sampah: ${data['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception(
          'Gagal menghapus jenis sampah: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
