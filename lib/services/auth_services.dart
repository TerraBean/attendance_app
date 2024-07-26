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

      // Update user data in Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'email': email,
        'role': 'user', // Default role
      }, SetOptions(merge: true)); // Merge to avoid overwriting existing data

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
}
