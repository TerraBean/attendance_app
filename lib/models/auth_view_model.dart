// ignore_for_file: use_build_context_synchronously

import 'package:attendance_app/screens/admin/admin_dashboard.dart';
import 'package:attendance_app/screens/home_screen.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/utils/device_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final firebaseService = FirestoreService();


  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _message = '';
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String get message => _message;
  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void setMessage(String value) {
    _message = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (_password != _confirmPassword) {
        setMessage('Passwords do not match');
        return;
      }

      setIsLoading(true);
      setMessage('');

      try {
        // Get device information
        final deviceInfo = await DeviceUtils.getDeviceId(context);
        if (deviceInfo == null) {
          throw Exception('Failed to get device information.');
        }

        // Call the registration method from AuthService
        await _authService.register(_email, _password, deviceInfo);
        setMessage('Registration successful!');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setMessage(
              'An account with this email already exists. Please try logging in or using a different email.');
        } else {
          setMessage(
              'An error occurred during registration. Please try again later.');
        }
      } catch (error) {
        setMessage(
            'An error occurred during registration. Please try again later.');
      } finally {
        setIsLoading(false);
      }
    }
  }

 Future<void> login(BuildContext context) async {
  if (formKey.currentState!.validate()) {
    setIsLoading(true);
    setMessage('');

    try {
      // Call the login method from AuthService
      User? user = await _authService.login(_email, _password, context);

      if (user != null) {
        bool isAdmin = await _authService.isAdmin(user.uid);

        // Call populateCurrentEmployee after successful login
        await firebaseService.populateCurrentEmployee(context);

        if (isAdmin) {
          // Navigate to Admin Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDashboard(),
            ),
          );
        } else {
          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                username: _email,
                userId: user.uid,
              ),
            ),
          );
        }
      } else {
        setMessage('Login failed');
      }
    } on Exception catch (error) {
      setMessage(error.toString());
    } finally {
      setIsLoading(false);
    }
  }
}

}
