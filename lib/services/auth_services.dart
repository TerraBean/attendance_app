import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      User? user = userCredential.user;

      // Update user data in Firestore (only if role is not already set)
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (!userDoc.exists || userDoc.get('role') == null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'role': 'user', // Default role
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<UserCredential?> register(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;

      // Add user data to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'email': email,
        'role': 'user', // Default role
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Error during registration: ${e.code}');
      return null;
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
}
