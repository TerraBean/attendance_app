import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Error signing in: ${e.code}');
    }
  }

  // Add other Firebase Authentication functions as needed, such as:
  // - createUserWithEmailAndPassword
  // - sendPasswordResetEmail
  // - signOut
  // - getCurrentUser
  // ...
}
