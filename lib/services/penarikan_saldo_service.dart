import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trasav/models/penarikan_saldo.dart';

class PenarikanSaldoService {
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

  Future<List<PenarikanSaldo>> getPenarikanSaldo({int? userId}) async {
    final headers = await _getHeaders();
    final uri = userId != null
        ? Uri.parse('$_baseUrl/penarikan-saldo?user_id=$userId')
        : Uri.parse('$_baseUrl/penarikan-saldo');
    final response = await http.get(uri, headers: headers);

    print('PenarikanSaldo Response Status: ${response.statusCode}');
    print('PenarikanSaldo Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = (data is List)
          ? data
          : (data['data'] as List? ?? []);
      print('Parsed PenarikanSaldo Items: $items');
      return items.map((item) => PenarikanSaldo.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat penarikan saldo: ${response.body}');
    }
  }

  Future<PenarikanSaldo> createPenarikanSaldo({
    required int userId,
    required double jumlah,
  }) async {
    final headers = await _getHeaders();
    final body = jsonEncode({'user_id': userId, 'jumlah': jumlah});

    final response = await http.post(
      Uri.parse('$_baseUrl/penarikan-saldo'),
      headers: headers,
      body: body,
    );

    print('Create PenarikanSaldo Response: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return PenarikanSaldo.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Gagal melakukan penarikan saldo: ${response.body}');
    }
  }
}
