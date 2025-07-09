import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trasav/models/notification.dart';

class OperatorNotificationService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<NotificationModel>> getOperatorNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      print('Fetching operator notifications');

      final response = await http.get(
        Uri.parse('$baseUrl/operator-notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(
        'Get Operator Notifications Response Status: ${response.statusCode}',
      );
      print('Get Operator Notifications Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load operator notifications: ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching operator notifications: $e');
      rethrow;
    }
  }
}
