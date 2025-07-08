import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trasav/models/user.dart';

class NasabahService {
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

  Future<List<User>> getNasabah() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/users?role=nasabah'),
      headers: headers,
    );

    print('Nasabah Response Status: ${response.statusCode}');
    print('Nasabah Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = (data is List)
          ? data
          : (data['data'] as List? ?? []);
      print('Parsed Nasabah Items: $items');
      return items.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data nasabah: ${response.body}');
    }
  }

  Future<User> createNasabah({
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    final headers = await _getHeaders();
    final body = jsonEncode({
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: headers,
      body: body,
    );

    print('Create Nasabah Response: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Gagal menambah nasabah: ${response.body}');
    }
  }

  Future<User> updateNasabah(
    int id, {
    String? name,
    String? email,
    String? phone,
    String? role,
  }) async {
    final headers = await _getHeaders();
    final body = jsonEncode({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (role != null) 'role': role,
    });

    final response = await http.put(
      Uri.parse('$_baseUrl/users/$id'),
      headers: headers,
      body: body,
    );

    print('Update Nasabah Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Gagal memperbarui nasabah: ${response.body}');
    }
  }

  Future<void> deleteNasabah(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/$id'),
      headers: headers,
    );

    print('Delete Nasabah Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus nasabah: ${response.body}');
    }
  }
}
