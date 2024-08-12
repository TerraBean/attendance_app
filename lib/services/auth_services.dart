import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/utils/device_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password, BuildContext context) async {
    try {
      // Trim leading and trailing spaces from email before login
      email = email.trim();

      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password.trim(),
      );
      User? user = userCredential.user;

      // Get the device ID
      String? deviceId = await DeviceUtils.getDeviceId(context);

      // Check if the device ID matches the user's device ID in Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        String? storedDeviceId = userDoc.get('deviceId');
        if (storedDeviceId != deviceId) {
          // Device ID mismatch, throw an error
          throw Exception('Cannot log in from this device.');
        }
      }

      // Update user data in Firestore (only if role is not already set)
      if (!userDoc.exists || userDoc.get('role') == null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'role': 'user', // Default role
          'deviceId': deviceId // Store the device ID
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
      }

      // After successful login, populate currentEmployee
      final firebaseService = Provider.of<FirestoreService>(context, listen: false);
      await firebaseService.populateCurrentEmployee(context);

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }


 Future<UserCredential?> register(String email, String password, String deviceInfo) async {
    try {
      // Attempt to sign in with the provided email and password
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      // If sign-in succeeds, it means the user already exists
      throw Exception('User with this email already exists.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // If sign-in fails with 'user-not-found', proceed to create a new user
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = credential.user;

        // Add user data to Firestore
        await _firestore.collection('users').doc(user!.uid).set({
          'email': email,
          'role': 'user', // Default role
          'deviceId': deviceInfo
        });

        return credential;
      } else {
        // Handle other authentication errors
        print('Error during registration: ${e.code}');
        throw e;
      }
    }
  }

  Future<bool> isAdmin(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        String? role = userDoc.get('role');
        return role == 'admin'; // Check if the role is 'admin'
      } else {
        return false; // User not found
      }
    } catch (e) {
      print('Error checking admin status: $e');
      return false; // Error occurred
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
