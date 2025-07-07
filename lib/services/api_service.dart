import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:8000'; // Ganti dengan URL API Laravel Anda saat production

  /// Login user dengan email dan password, return User model
  static Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        final data = jsonDecode(response.body);
        throw (data['message'] ?? 'Login gagal, periksa kredensial Anda.');
      }
    } catch (e) {
      throw '$e';
    }
  }

  /// Register user baru dengan name, email, phone, password
  static Future<void> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
          // Tidak perlu mengirim role karena sudah hardcoded 'nasabah' di Laravel
        }),
      );

      if (response.statusCode == 201) {
        // Registrasi berhasil
        return;
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Validasi gagal: ${data['errors']}');
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Registrasi gagal.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi: $e');
    }
  }
}
