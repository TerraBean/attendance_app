import 'package:attendance_app/presentation/screens/login.dart';
import 'package:attendance_app/presentation/screens/registration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendance_app/models/auth_view_model.dart';
import 'package:attendance_app/presentation/widgets/common_widgets.dart';

class AuthForm extends StatelessWidget {
  final bool isRegistration;

  const AuthForm({Key? key, required this.isRegistration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: authViewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
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
                  isRegistration
                      ? 'Sign up to get started'
                      : 'Login to continue',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Input
                InputField(
                  hintText: 'Email',
                  labelText: 'Email',
                  onChanged: authViewModel.setEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 20),

                // Additional fields for Registration
                if (isRegistration) ...[
                  InputField(
                    hintText: 'First Name',
                    labelText: 'First Name',
                    onChanged: authViewModel.setFirstName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    hintText: 'Last Name',
                    labelText: 'Last Name',
                    onChanged: authViewModel.setLastName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    hintText: 'Phone Number',
                    labelText: 'Phone Number',
                    onChanged: authViewModel.setPhoneNumber,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                ],

                // Password Input
                InputField(
                  hintText: 'Password',
                  labelText: 'Password',
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
                if (isRegistration) ...[
                  const SizedBox(height: 20),
                  InputField(
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                    obscureText: true,
                    onChanged: authViewModel.setConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outline,
                  ),
                ],
                const SizedBox(height: 20),

                // Login or Register Button
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

                // Error message display
                if (authViewModel.message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      authViewModel.message,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),

                // Switch between Login and Registration
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
