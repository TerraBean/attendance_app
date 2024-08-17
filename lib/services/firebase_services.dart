// ignore_for_file: use_build_context_synchronously

import 'package:attendance_app/models/location_model.dart';
import 'package:attendance_app/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cache for employee data
  // Cache for employee data
  final Map<String, Employee> _employeeCache = {}; // Use Employee object

  Map<String, Employee> get employeeCache => _employeeCache;

  Map<String, List<Map<String, dynamic>>> _timeEntriesByUser = {};



 
  Future<List<Employee>> getEmployees() async { // Return List<Employee>
    try {
      if (_employeeCache.isEmpty) {
        // Get all users from the 'users' collection
        QuerySnapshot snapshot = await _db.collection('users').get();

        // Extract user data from the snapshot and store in cache using Employee object
        for (var doc in snapshot.docs) {
          _employeeCache[doc.id] = Employee.fromJson(doc.data() as Map<String, dynamic>); // Use Employee.fromJson
        }
      }
      return _employeeCache.values.toList(); // Return List<Employee>
    } catch (e) {
      print('Error getting registered accounts: $e');
      return [];
    }
  }

  // Variable to store the current Employee
  Employee? _currentEmployee;

  Employee? get currentEmployee => _currentEmployee;

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

  Future<Map<String, dynamic>?> getEmployee(String uid) async {
    try {
      // Get the user document from Firestore
      DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();

      // If the document exists, return the data as a Map
      if (snapshot.exists) {
        // Update the _currentEmployee variable
        _currentEmployee =
            Employee.fromJson(snapshot.data() as Map<String, dynamic>);
        notifyListeners(); // Notify listeners that the currentEmployee has changed
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting employee data: $e');
    }
    return null; // Return null if the document doesn't exist or an error occurs
  }

  // Function to populate _currentEmployee during login
  Future<void> populateCurrentEmployee(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Get the user document from Firestore
        DocumentSnapshot snapshot =
            await _db.collection('users').doc(user.uid).get();

        // If the document exists, update _currentEmployee
        if (snapshot.exists) {
          print('Snapshot data');
          print(snapshot.data());
          _currentEmployee =
              Employee.fromJson(snapshot.data() as Map<String, dynamic>);

          // Test if _currentEmployee was populated
        if (_currentEmployee != null) {
          print('Current employee populated successfully!');
          // print currentemployee id
          print('Current Employee ID: ${user.uid}');
          print('First Name: ${_currentEmployee!.firstName}');
          print('Last Name: ${_currentEmployee!.lastName}');
          // Add more properties to check as needed
        } else {
          print('Error populating _currentEmployee. It is null.');
        }

          notifyListeners(); // Notify listeners that the currentEmployee has changed
        }
      }
    } catch (e) {
      print('Error populating current employee: $e');
    }
  }

// ... (Existing code in FirestoreService)

 Future<void> updateUser(
     String?  uid, String firstName, String lastName, String phoneNumber) async {
   try {
    User? user = _auth.currentUser;
    // print currentemployee
    print('Current Employee: ${_currentEmployee!.firstName} ${_currentEmployee!.lastName}');
    //print currentemployee id
    print('Current Employee ID: ${user?.uid}');
     // Update the user document in Firestore
     print('updating..');
     await _db.collection('users').doc(user?.uid).update({
       'firstName': firstName,
       'lastName': lastName,
       'phoneNumber': phoneNumber,
     });
     
 
     // Update the local employeeCache if necessary
     if (_employeeCache.containsKey(uid)) {
       _employeeCache[uid]!.firstName = firstName;
       _employeeCache[uid]!.lastName = lastName;
       _employeeCache[uid]!.phoneNumber = phoneNumber;

       notifyListeners();
     }
 
     // Update the _currentEmployee if the updated user is the current user
     if (_currentEmployee?.uid == uid) {
       _currentEmployee!.firstName = firstName; // Now you can assign a new value
       _currentEmployee!.lastName = lastName; // Now you can assign a new value
       _currentEmployee!.phoneNumber = phoneNumber;
       notifyListeners();
     }
   } catch (e) {
     print('Error updating user: $e');
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



   Future<List<Map<String, dynamic>>> fetchUsersWithTimeEntries() async {
    List<Map<String, dynamic>> usersWithTimeEntries = [];

    try {
      // Get all users from the 'users' collection
      QuerySnapshot usersSnapshot = await _db.collection('users').get();

      // Iterate through each user document
      for (var userDoc in usersSnapshot.docs) {
        // Get the user's ID
        String userId = userDoc.id;

        // Get the user's data
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Get the time entries for the user
        QuerySnapshot timeEntriesSnapshot = await _db
            .collection('users')
            .doc(userId)
            .collection('timeEntries')
            .get();

        // Create a list to store the time entries
        List<Map<String, dynamic>> timeEntries = [];

        // Iterate through each time entry document
        for (var timeEntryDoc in timeEntriesSnapshot.docs) {
          // Get the time entry data
          Map<String, dynamic> timeEntryData =
              timeEntryDoc.data() as Map<String, dynamic>;

          // Add the time entry data to the list
          timeEntries.add(timeEntryData);
        }

        // Add the user data and time entries to the list
        usersWithTimeEntries.add({
          'user': userData,
          'timeEntries': timeEntries,
        });
      }

      return usersWithTimeEntries;
    } catch (e) {
      print('Error fetching users with time entries: $e');
      return [];
    }
  }

Future<List<Map<String, dynamic>>> weekAttendance() async {
  List<Map<String, dynamic>> usersWithTimeEntries = [];

  try {
    // Get the current date and calculate the start (Monday) and end (Friday) of the current week
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime friday = monday.add(const Duration(days: 4));
    
    // Set the time of both monday and friday to the start of the day
    monday = DateTime(monday.year, monday.month, monday.day, 0, 0, 0);
    friday = DateTime(friday.year, friday.month, friday.day, 23, 59, 59);

    // Get all users from the 'users' collection
    QuerySnapshot usersSnapshot = await _db.collection('users').get();

    // Iterate through each user document
    for (var userDoc in usersSnapshot.docs) {
      // Get the user's ID
      String userId = userDoc.id;

      // Get the user's data
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Get the time entries for the user within the current week
      QuerySnapshot timeEntriesSnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('timeEntries')
          .where('date', isGreaterThanOrEqualTo: monday)
          .where('date', isLessThanOrEqualTo: friday)
          .get();

      // Create a list to store the time entries
      List<Map<String, dynamic>> timeEntries = [];

      // Iterate through each time entry document
      for (var timeEntryDoc in timeEntriesSnapshot.docs) {
        // Get the time entry data
        Map<String, dynamic> timeEntryData = timeEntryDoc.data() as Map<String, dynamic>;

        // Add the time entry data to the list
        timeEntries.add(timeEntryData);
      }

      // Add the user data and time entries to the list only if there are time entries
      if (timeEntries.isNotEmpty) {
        usersWithTimeEntries.add({
          'user': userData,
          'timeEntries': timeEntries,
        });
      }
    }

    return usersWithTimeEntries;
  } catch (e) {
    print('Error fetching users with time entries for the current week: $e');
    return [];
  }
}
}
