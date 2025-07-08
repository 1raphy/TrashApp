import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trasav/models/setoran_sampah.dart';
import 'package:trasav/models/jenis_sampah.dart';

class SetoranSampahService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('Auth Token: $token');
    return token;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<JenisSampah>> getJenisSampah() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/jenis-sampah-index'),
      headers: headers,
    );

    print('JenisSampah Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = (data is List)
          ? data
          : (data['data'] as List? ?? []);
      return items.map((item) => JenisSampah.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat jenis sampah: ${response.body}');
    }
  }

  Future<List<SetoranSampah>> getSetoranSampah() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/setoran-sampah'),
      headers: headers,
    );

    print('SetoranSampah Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = (data is List)
          ? data
          : (data['data'] as List? ?? []);
      return items.map((item) => SetoranSampah.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat setoran sampah: ${response.body}');
    }
  }

  Future<SetoranSampah> createSetoranSampah({
    required int jenisSampahId,
    required double beratKg,
    required String metodePenjemputan,
    String? alamatPenjemputan,
    String? catatanTambahan,
  }) async {
    final headers = await _getHeaders();
    final body = jsonEncode({
      'jenis_sampah_id': jenisSampahId,
      'berat_kg': beratKg,
      'metode_penjemputan': metodePenjemputan,
      if (alamatPenjemputan != null) 'alamat_penjemputan': alamatPenjemputan,
      if (catatanTambahan != null) 'catatan_tambahan': catatanTambahan,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/setoran-sampah'),
      headers: headers,
      body: body,
    );

    print('Create SetoranSampah Response: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return SetoranSampah.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Gagal menyimpan setoran sampah: ${response.body}');
    }
  }

  Future<SetoranSampah> updateStatusSetoranSampah(int id, String status) async {
    final headers = await _getHeaders();
    final body = jsonEncode({'status': status});

    final response = await http.put(
      Uri.parse('$_baseUrl/setoran-sampah/$id/status'),
      headers: headers,
      body: body,
    );

    print('Update Status SetoranSampah Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SetoranSampah.fromJson(data['data'] ?? data);
    } else {
      throw Exception(
        'Gagal memperbarui status setoran sampah: ${response.body}',
      );
    }
  }

  Future<List<PenarikanSaldo>> getPenarikanSaldo() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/penarikan-saldo'),
      headers: headers,
    );

    print('PenarikanSaldo Status Code: ${response.statusCode}');
    print('PenarikanSaldo Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = (data is List)
          ? data
          : (data['data'] as List? ?? []);
      return items.map((item) => PenarikanSaldo.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat penarikan saldo: ${response.body}');
    }
  }
}
