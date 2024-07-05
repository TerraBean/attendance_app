import 'dart:convert';
import 'package:attendance_app/models/user_info.dart';
import 'package:http/http.dart' as http;

class UserApi {

// fetch users from the api
  static Future<List<User>> fetchUsers() async {
    final url = Uri.parse('https://user-data.up.railway.app/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // login user
  static Future<User> fetchUser(String userId) async {
    final url = Uri.parse('https://user-data.up.railway.app/users/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }

  // login user
  static Future<LoginResponse> loginUser(
      String username, String password) async {
    final url = Uri.parse(
        'https://user-data.up.railway.app/users/login'); // Replace with your actual API endpoint
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

  

  
  static Future<void> recordTimeEntry(String userId) async {
    final url = Uri.parse('https://user-data.up.railway.app/timeentry');
    final body = {'userId': userId};
    final headers = {'Content-Type': 'application/json'};
    final bodyJson = jsonEncode(body);

    try {
      final response = await http.post(url, headers: headers, body: bodyJson);
      final statusCode = response.statusCode;

      if (statusCode == 201) {
        // Time entry recorded successfully
        print('Time entry recorded successfully');
      } else {
        final error = jsonDecode(response.body)['message'];
        throw Exception('Failed to record time entry: $error');
      }
    } catch (error) {
      throw Exception('Error recording time entry: $error');
    }
  }
}
