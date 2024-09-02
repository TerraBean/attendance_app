
import 'package:attendance_app/models/auth_view_model.dart';
import 'package:attendance_app/presentation/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        create: (context) => AuthViewModel(),
        child: AuthForm(isRegistration: false),
      ),
    );
  }
}
