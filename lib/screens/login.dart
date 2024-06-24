
import 'package:attendance_app/services/user_api.dart';
import 'package:flutter/material.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';
  String _loginMessage = '';

  Future<void> _handleLogin() async {
    try {
      final loginResponse = await UserApi.loginUser(_username, _password);
      setState(() {
        _loginMessage = loginResponse.message;
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
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10.0),
            Text(_loginMessage),
          ],
        ),
      ),
    );
  }
}