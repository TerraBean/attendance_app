// ignore_for_file: use_build_context_synchronously

import 'package:attendance_app/models/location_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // Cache for employee data
  Map<String, Map<String, dynamic>> _employeeCache = {};

  Map<String, Map<String, dynamic>> get employeeCache => _employeeCache;

  Map<String, List<Map<String, dynamic>>> _timeEntriesByUser = {};
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
        DateTime todayEnd = todayStart.add(const Duration(days: 1));

        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .where('date', isGreaterThanOrEqualTo: todayStart)
            .where('date', isLessThan: todayEnd)
            .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
          const SnackBar(
            content: Text('Clocked in successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error clocking in: $e');
    }
  }


 Future<void> clockOut(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DateTime today = DateTime.now();
        DateTime todayStart = DateTime(today.year, today.month, today.day);
        DateTime todayEnd = todayStart.add(const Duration(days: 1));

        QuerySnapshot snapshot = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .where('date', isGreaterThanOrEqualTo: todayStart)
            .where('date', isLessThan: todayEnd)
            .get();

        if (snapshot.docs.isEmpty) {
          // No clock-in record found for today
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have to clock in first.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        // Find the latest clock-in record
        DocumentSnapshot latestClockIn = snapshot.docs.last;

        // Check if the latest clock-in record has a clockedOut timestamp
        if (latestClockIn.get('clockedOut') != null) {
          // User has already clocked out
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have already clocked out.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        // Update the clock-in record with the clock-out timestamp
        await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .doc(latestClockIn.id)
            .update({
          'clockedOut': FieldValue.serverTimestamp(),
        });

        // Update the local cache
        _timeEntriesByUser[user.uid]!.last['clockedOut'] = DateTime.now();

        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Clocked out successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error clocking out: $e');
    }
  }


  Future<double?> getRadius() async {
    try {
      // Get the latest radius document
      DocumentSnapshot snapshot =
          await _db.collection('radius').doc("admin_radius").get();

      if (snapshot.exists) {
        // Extract the radius from the document
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double radius = data['radius'];

        return radius;
      } else {
        print('Snapshot was empty');
      }
    } catch (e) {
      print('Error getting radius: $e');
    }
    return null; // Return null if no radius found
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
