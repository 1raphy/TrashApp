import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:8000'; // Ganti dengan URL produksi

  // Simpan token untuk digunakan di semua request
  static String? _token;

  // Getter untuk token
  static String? get token => _token;

  // Simpan token ke SharedPreferences
  static Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  // Hapus token
  static Future<void> removeToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Header default dengan token jika ada
  static Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  /// Login user dengan email dan password
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data['access_token']);
        return {
          'user': User.fromJson(data['user']),
          'token': data['access_token'],
        };
      } else {
        final data = jsonDecode(response.body);
        throw Exception(
          data['message'] ?? 'Login gagal, periksa kredensial Anda.',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login: $e');
    }
  }

  /// Register user baru
  static Future<Map<String, dynamic>> register(
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
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await saveToken(data['access_token']);
        return {
          'user': User.fromJson(data['user']),
          'token': data['access_token'],
        };
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        throw Exception(
          data['errors'] != null
              ? data['errors'].values.join(', ')
              : 'Validasi gagal',
        );
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Registrasi gagal.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi: $e');
    }
  }

  /// Logout user
  static Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/logout'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        await removeToken();
        return;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Logout gagal.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat logout: $e');
    }
  }

  /// Mendapatkan data user yang sedang login
  static Future<User> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Gagal mendapatkan data user.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mendapatkan data user: $e');
    }
  }

  /// Mendapatkan daftar jenis sampah
  static Future<List<dynamic>> getJenisSampah() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/jenis-sampah'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final data = jsonDecode(response.body);
        throw Exception(
          data['message'] ?? 'Gagal mendapatkan daftar jenis sampah.',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mendapatkan jenis sampah: $e');
    }
  }

  /// Mendapatkan daftar setoran sampah
  static Future<List<dynamic>> getSetoranSampah() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/setoran-sampah'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final data = jsonDecode(response.body);
        throw Exception(
          data['message'] ?? 'Gagal mendapatkan daftar setoran sampah.',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mendapatkan setoran sampah: $e');
    }
  }

  /// Mengajukan setoran sampah
  static Future<void> submitSetoran(int jenisSampahId, double beratKg) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/setoran-sampah'),
        headers: _getHeaders(),
        body: jsonEncode({
          'jenis_sampah_id': jenisSampahId,
          'berat_kg': beratKg,
        }),
      );

      if (response.statusCode == 201) {
        return;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Gagal mengajukan setoran sampah.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengajukan setoran: $e');
    }
  }

  /// Mengajukan penarikan saldo
  static Future<void> submitPenarikan(double jumlah) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/penarikan-saldo'),
        headers: _getHeaders(),
        body: jsonEncode({'jumlah': jumlah}),
      );

      if (response.statusCode == 201) {
        return;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Gagal mengajukan penarikan saldo.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengajukan penarikan: $e');
    }
  }
}
