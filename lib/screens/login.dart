import 'package:attendance_app/screens/admin/admin_dashboard.dart';
import 'package:attendance_app/screens/home_screen.dart';
import 'package:attendance_app/services/admin_api.dart';
import 'package:attendance_app/services/user_api.dart';
import 'package:flutter/material.dart';

import 'admin/admin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';
  String _loginMessage = '';
  String _userId = '';
  bool adminSelected = false; // Declare adminSelected as a state variable

  Future<void> _handleLogin(bool adminSelected) async {
    try {
      final loginResponse = adminSelected
          ? await AdminApi.loginAdmin(_username, _password)
          : await UserApi.loginUser(_username, _password);
      setState(() {
        _loginMessage = loginResponse.message;
        _userId = loginResponse.userId;

        switch (_loginMessage) {
          case 'Login was a successful':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(username: _username, userId: _userId),
              ),
            );
            break;
          case 'Admin login successful':
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Admin(),
                ));
            break;
          default:

            break;
        }

  
      });
    } on Exception catch (error) {
      setState(() {
        _loginMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) => setState(() => _username = value),
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) => setState(() => _password = value),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () =>
                  _handleLogin(adminSelected), // Pass adminSelected
              child: const Text('Login'),
            ),
            // generate a check box which when checked will make adminSelected becomes true and vice versa
            Checkbox(
              value: adminSelected, // Bind value to adminSelected
              onChanged: (value) {
                setState(() {
                  adminSelected = value!;
                  // print the value of adminSelected
                });
              },
            ),
            const Text('Admin'),
            const SizedBox(height: 10.0),
            Text(_loginMessage),
          ],
        ),
      ),
    );
  }
}
