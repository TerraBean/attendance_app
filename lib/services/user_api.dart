import 'dart:convert';
import 'package:attendance_app/models/user_info.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=20'));
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;
  
    final users = results.map((user) {
      var name = UserName(
          title: user['name']['title'],
          first: user['name']['first'],
          last: user['name']['last']);

      return User(gender: user['gender'], email: user['email'], phone: user['phone'], name: name);
    }).toList();
    return users;
  }

  static Future<LoginResponse> loginUser(String username, String password) async {
  final url = Uri.parse('https://user-data.up.railway.app/login'); // Replace with your actual API endpoint
  final body = {
    "username":username,
    "password": password
};
final headers = {'Content-Type': 'application/json'};
  final bodyJson = jsonEncode(body);
  try {
    final response = await http.post(url,headers: headers, body: bodyJson);
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
