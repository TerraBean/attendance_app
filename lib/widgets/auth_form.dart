import 'package:attendance_app/models/auth_view_model.dart';
import 'package:attendance_app/screens/login.dart';
import 'package:attendance_app/screens/registration.dart';
import 'package:attendance_app/widgets/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthForm extends StatelessWidget {
  final bool isRegistration;

  const AuthForm({Key? key, required this.isRegistration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true, // Automatically resize when the keyboard appears
      body: SafeArea(
        child: SingleChildScrollView( // Makes the content scrollable
          child: Form(
            key: authViewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  isRegistration ? 'Create Account' : 'Welcome Back!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isRegistration ? 'Sign up to get started' : 'Login to continue',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                InputField(
                  hintText: 'Email',
                  onChanged: authViewModel.setEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 20),
                InputField(
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: authViewModel.setPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  prefixIcon: Icons.lock,
                ),
                if (isRegistration)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      InputField(
                        hintText: 'Confirm Password',
                        obscureText: true,
                        onChanged: authViewModel.setConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          return null;
                        },
                        prefixIcon: Icons.lock,
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                AuthButton(
                  text: isRegistration ? 'Sign Up' : 'Login',
                  onPressed: () {
                    if (isRegistration) {
                      authViewModel.register(context);
                    } else {
                      authViewModel.login(context);
                    }
                  },
                  isLoading: authViewModel.isLoading,
                ),
                const SizedBox(height: 20),
                MessageDisplay(message: authViewModel.message),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: isRegistration
                        ? "Already have an account? "
                        : "Don't have an account? ",
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: isRegistration ? 'Login' : 'Sign up',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => isRegistration
                                    ? LoginPage()
                                    : RegistrationPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
