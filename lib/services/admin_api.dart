

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:attendance_app/models/user_info.dart';

class AdminApi {

  static Future<LoginResponse> loginAdmin(
      String username, String password) async {
    final url = Uri.parse(
        'https://user-data.up.railway.app/admin/login'); // Replace with your actual API endpoint
    final body = {"username": username, "password": password};
    final headers = {'Content-Type': 'application/json'};
    final bodyJson = jsonEncode(body);
    try {
      final response = await http.post(url, headers: headers, body: bodyJson);
      final statusCode = response.statusCode;


      if (statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else {
        final error = jsonDecode(response.body)['message'];
        throw Exception('Login failed: $error');
      }
    } catch (error) {
      throw Exception('Error logging in user: $error');
    }
  }
  
}