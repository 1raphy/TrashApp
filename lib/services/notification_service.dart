import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trasav/models/notification.dart';

class NotificationService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<NotificationModel>> getNotifications({
    required int userId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      print('Fetching notifications for userId: $userId');

      final response = await http.get(
        Uri.parse('$baseUrl/notifications?user_id=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Get Notifications Response Status: ${response.statusCode}');
      print('Get Notifications Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load notifications: ${response.body}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      rethrow;
    }
  }
}
