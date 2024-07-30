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

  Future<void> clockIn(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check if the user has already clocked in today
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
          // User has already clocked in today
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have already clocked in today.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        // Clock in if the user hasn't clocked in today
        DocumentReference docRef = await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .add({
          'clockedIn': FieldValue.serverTimestamp(),
          'clockedOut': null,
          'date': DateTime.now(),
        });

        // Update the local time entries map
        _timeEntriesByUser[user.uid] ??= [];
        _timeEntriesByUser[user.uid]!.add({
          'id': docRef.id,
          'clockedIn': FieldValue.serverTimestamp(),
          'clockedOut': null,
          'date': DateTime.now(),
        });

        notifyListeners(); // Notify listeners of the change

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

        // Update the local time entries map
        if (_timeEntriesByUser.containsKey(user.uid)) {
          int index = _timeEntriesByUser[user.uid]!
              .indexWhere((entry) => entry['id'] == timeEntryId);
          if (index != -1) {
            _timeEntriesByUser[user.uid]![index]['clockedOut'] =
                FieldValue.serverTimestamp();
            notifyListeners(); // Notify listeners of the change
          }
        }
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

        // Update the local time entries map
        _timeEntriesByUser[user.uid] = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        notifyListeners(); // Notify listeners of the change
      }
    } catch (e) {
      print('Error getting time entries: $e');
    }
  }

  Future<void> updateCenterLocation(double latitude, double longitude) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;
      if (user != null) {
        // Check if the user is the designated admin
        if (user.uid == "ZpAqV9ExJ2QxAHWvcGmqd1AdkOn2") { // Replace with your admin's ID
          // Add the coordinates to the 'coordinates' collection
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
      // Get the latest coordinate document
      DocumentSnapshot snapshot = await _db.collection('coordinates').doc("admin_coordinates").get();

      if (snapshot.exists) {
        // Extract latitude and longitude from the document
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double latitude = data['latitude'];
        double longitude = data['longitude'];

        print('Snapshot is not empty');
        // print longitude and latitude
        print('Latitude: $latitude, Longitude: $longitude');

        // Return the coordinates as a LocationModel object
        return LocationModel(latitude: latitude, longitude: longitude);
      } else {
        print('Snapshot was empty');
      }
    } catch (e) {
      print('Error getting coordinates: $e');
    }
    return null; // Return null if no coordinates found
  }
}
