import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> clockIn() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _db.collection('users').doc(user.uid).collection('timeEntries').add({
          'clockedIn': FieldValue.serverTimestamp(),
          'clockedOut': null,
          'date': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error clocking in: $e');
    }
  }

  

  Future<void> clockOut(String timeEntryId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .doc(timeEntryId)
            .update({
          'clockedOut': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error clocking out: $e');
    }
  }

  Future<QuerySnapshot> getTimeEntries() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return _db.collection('users').doc(user.uid).collection('timeEntries').get();
    } else {
      throw Exception('No user logged in');
    }
  }
}
