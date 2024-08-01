import 'package:attendance_app/models/location_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Data to be observed for changes
  Map<String, List<Map<String, dynamic>>> _timeEntriesByUser = {};

  // Getter for the time entries by user
  Map<String, List<Map<String, dynamic>>> get timeEntriesByUser =>
      _timeEntriesByUser;

  // Cache for employee data
  Map<String, Map<String, dynamic>> _employeeCache = {};

  Future<List<Map<String, dynamic>>> getEmployees() async {
    try {
      if (_employeeCache.isEmpty) {
        // Get all users from the 'users' collection
        QuerySnapshot snapshot = await _db.collection('users').get();

        // Extract user data from the snapshot and store in cache
        for (var doc in snapshot.docs) {
          _employeeCache[doc.id] = doc.data() as Map<String, dynamic>;
        }
      }
      return _employeeCache.values.toList();
    } catch (e) {
      print('Error getting registered accounts: $e');
      return [];
    }
  }

  Future<void> clockIn(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DateTime today = DateTime.now();
        DateTime todayStart = DateTime(today.year, today.month, today.day);
        DateTime todayEnd = todayStart.add(Duration(days: 1));

        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .where('date', isGreaterThanOrEqualTo: todayStart)
            .where('date', isLessThan: todayEnd)
            .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have already clocked in today.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        DocumentReference docRef = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .add({
          'clockedIn': FieldValue.serverTimestamp(),
          'clockedOut': null,
          'date': DateTime.now(),
        });

        _timeEntriesByUser[user.uid] ??= [];
        _timeEntriesByUser[user.uid]!.add({
          'id': docRef.id,
          'clockedIn': DateTime.now(),
          'clockedOut': null,
          'date': DateTime.now(),
        });

        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Clocked in successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error clocking in: $e');
    }
  }

  Future<void> clockOut(String timeEntryId, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DateTime today = DateTime.now();
        DateTime todayStart = DateTime(today.year, today.month, today.day);
        DateTime todayEnd = todayStart.add(Duration(days: 1));

        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .where('date', isGreaterThanOrEqualTo: todayStart)
            .where('date', isLessThan: todayEnd)
            .where('clockedOut', isNotEqualTo: null)
            .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have already clocked out today.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .doc(timeEntryId)
            .update({
          'clockedOut': FieldValue.serverTimestamp(),
        });

        if (_timeEntriesByUser.containsKey(user.uid)) {
          int index = _timeEntriesByUser[user.uid]!
              .indexWhere((entry) => entry['id'] == timeEntryId);
          if (index != -1) {
            _timeEntriesByUser[user.uid]![index]['clockedOut'] = DateTime.now();
            notifyListeners();
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Clocked out successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error clocking out: $e');
    }
  }

  Future<void> getTimeEntries() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .get();

        _timeEntriesByUser[user.uid] = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error getting time entries: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTimeEntriesForToday() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DateTime today = DateTime.now();
        DateTime todayStart = DateTime(today.year, today.month, today.day);
        DateTime todayEnd = todayStart.add(Duration(days: 1));

        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .where('date', isGreaterThanOrEqualTo: todayStart)
            .where('date', isLessThan: todayEnd)
            .get();

        List<Map<String, dynamic>> timeEntries = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();

        return timeEntries;
      }
    } catch (e) {
      print('Error getting time entries for today: $e');
    }
    return [];
  }

  Future<String?> getLastTimeEntryId() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.id;
        }
      }
    } catch (e) {
      print('Error getting last time entry ID: $e');
    }
    return null;
  }

  Future<void> updateCenterLocation(double latitude, double longitude) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        if (user.uid == "ZpAqV9ExJ2QxAHWvcGmqd1AdkOn2") {
          await _db.collection('coordinates').doc("admin_coordinates").set({
            'latitude': latitude,
            'longitude': longitude,
          });
        } else {
          print('Only the designated admin can set coordinates.');
        }
      }
    } catch (e) {
      print('Error updating center location: $e');
    }
  }

  Future<LocationModel?> getCoordinates() async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection('coordinates').doc("admin_coordinates").get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double latitude = data['latitude'];
        double longitude = data['longitude'];

        return LocationModel(latitude: latitude, longitude: longitude);
      }
    } catch (e) {
      print('Error getting coordinates: $e');
    }
    return null;
  }

  Future<void> updateRadius(double radius) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        if (user.uid == "ZpAqV9ExJ2QxAHWvcGmqd1AdkOn2") {
          await _db.collection('radius').doc("admin_radius").set({
            'radius': radius,
          });
        } else {
          print('Only the designated admin can set the radius.');
        }
      }
    } catch (e) {
      print('Error updating radius: $e');
    }
  }
}
