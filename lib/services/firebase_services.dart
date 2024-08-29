// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:attendance_app/models/location_model.dart';
import 'package:attendance_app/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cache for employee data
  final Map<String, Employee> _employeeCache = {};
  final Map<String, List<Employee>> _usersWithTimeEntriesCache = {};

  // Stream subscription for listening to changes in the 'users' collection
  StreamSubscription? _usersSubscription;

  Map<String, Employee> get employeeCache => _employeeCache;

  Map<String, List<Employee>> get usersWithTimeEntriesCache =>
      _usersWithTimeEntriesCache;

  Map<String, List<Map<String, dynamic>>> _timeEntriesByUser = {};

  Future<List<Employee>> getEmployees() async {
    try {
      if (_employeeCache.isEmpty) {
        QuerySnapshot snapshot = await _db.collection('users').get();
        for (var doc in snapshot.docs) {
          _employeeCache[doc.id] = Employee.fromJson(
              doc.data() as Map<String, dynamic>);
        }
      }
      return _employeeCache.values.toList();
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
      DocumentSnapshot snapshot = await _db.collection('users').doc(uid).get();
      if (snapshot.exists) {
        _currentEmployee =
            Employee.fromJson(snapshot.data() as Map<String, dynamic>);
        notifyListeners();
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting employee data: $e');
    }
    return null;
  }

  Future<void> populateCurrentEmployee(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _db.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          _currentEmployee =
              Employee.fromJson(snapshot.data() as Map<String, dynamic>);
          if (_currentEmployee != null) {
            print('Current employee populated successfully!');
            print('Current Employee ID: ${user.uid}');
            print('First Name: ${_currentEmployee!.firstName}');
            print('Last Name: ${_currentEmployee!.lastName}');
          } else {
            print('Error populating _currentEmployee. It is null.');
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error populating current employee: $e');
    }
  }

  Future<void> updateUser(String? uid, String firstName, String lastName,
      String phoneNumber) async {
    try {
      User? user = _auth.currentUser;
      print(
          'Current Employee: ${_currentEmployee!.firstName} ${_currentEmployee!.lastName}');
      print('Current Employee ID: ${user?.uid}');
      print('updating..');
      await _db.collection('users').doc(user?.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      });

      if (_employeeCache.containsKey(uid)) {
        _employeeCache[uid]!.firstName = firstName;
        _employeeCache[uid]!.lastName = lastName;
        _employeeCache[uid]!.phoneNumber = phoneNumber;
        notifyListeners();
      }

      if (_currentEmployee?.uid == uid) {
        _currentEmployee!.firstName = firstName;
        _currentEmployee!.lastName = lastName;
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have to clock in first.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        DocumentSnapshot latestClockIn = snapshot.docs.last;
        if (latestClockIn.get('clockedOut') != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have already clocked out.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        await _db
            .collection('users')
            .doc(user.uid)
            .collection('timeEntries')
            .doc(latestClockIn.id)
            .update({
          'clockedOut': FieldValue.serverTimestamp(),
        });

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
      DocumentSnapshot snapshot =
          await _db.collection('radius').doc("admin_radius").get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double radius = data['radius'];
        return radius;
      } else {
        print('Snapshot was empty');
      }
    } catch (e) {
      print('Error getting radius: $e');
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

  Future<List<Employee>> fetchUsersWithTimeEntries() async {
    // Check if the data is already in the cache
    if (_usersWithTimeEntriesCache.containsKey('allUsers')) {
      print('Returning cached data for fetchUsersWithTimeEntries');
      return _usersWithTimeEntriesCache['allUsers']!;
    }

    List<Employee> usersWithTimeEntries = [];

    try {
      QuerySnapshot usersSnapshot = await _db.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        QuerySnapshot timeEntriesSnapshot = await _db
            .collection('users')
            .doc(userId)
            .collection('timeEntries')
            .get();

        List<Map<String, dynamic>> timeEntries = [];
        for (var timeEntryDoc in timeEntriesSnapshot.docs) {
          Map<String, dynamic> timeEntryData =
              timeEntryDoc.data() as Map<String, dynamic>;
          timeEntries.add(timeEntryData);
        }

        // Create an Employee object and add it to the list
        Employee employee = Employee.fromJson(userData);

        // Convert the list of maps to a list of TimeEntry objects
        employee.timeEntries = timeEntries
            .map((timeEntryData) => TimeEntry.fromJson(timeEntryData))
            .toList();

        usersWithTimeEntries.add(employee);
      }

      print("printing users with time entries ..............");
      print(usersWithTimeEntries);

      // Cache the data
      _usersWithTimeEntriesCache['allUsers'] = usersWithTimeEntries;
      notifyListeners();
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
          Map<String, dynamic> timeEntryData =
              timeEntryDoc.data() as Map<String, dynamic>;

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
      print('Printing week attendance..................');
      print(usersWithTimeEntries);
      return usersWithTimeEntries;
    } catch (e) {
      print('Error fetching users with time entries for the current week: $e');
      return [];
    }
  }
  // Start listening to changes in the 'users' collection
  void startUsersListener() {
    _usersSubscription = _db.collection('users').snapshots().listen((snapshot) {
      // Clear the cache before updating
      _usersWithTimeEntriesCache.clear();

      for (var doc in snapshot.docs) {
        String userId = doc.id;
        _updateUserCache(doc);

        // Set up a listener for the user's timeEntries
        _db.collection('users')
            .doc(userId)
            .collection('timeEntries')
            .snapshots()
            .listen((timeEntriesSnapshot) {
          _updateTimeEntriesCache(userId, timeEntriesSnapshot);
          notifyListeners(); // Notify listeners whenever timeEntries change
        });
      }

      notifyListeners(); // Notify listeners after updating the users cache
    });
  }

  // Update the user cache
  void _updateUserCache(DocumentSnapshot doc) {
    Employee employee = Employee.fromJson(doc.data() as Map<String, dynamic>);

    // Store the user in the cache
    _employeeCache[doc.id] = employee;

    // Initialize the user's time entries in the cache
    _usersWithTimeEntriesCache[doc.id] = [];
  }

  // Update the time entries cache
  void _updateTimeEntriesCache(String userId, QuerySnapshot timeEntriesSnapshot) {
    if (_employeeCache.containsKey(userId)) {
      Employee employee = _employeeCache[userId]!;

      // Update the employee's time entries
      employee.timeEntries = timeEntriesSnapshot.docs.map((doc) {
        return TimeEntry.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      // Update the cache
      _usersWithTimeEntriesCache[userId] = [employee];
    }
  }

   void clearCache() {
    _employeeCache.clear();
    _usersWithTimeEntriesCache.clear();
    // Clear other caches or reset any user-specific state
    notifyListeners();
  }

   // Ensure you unsubscribe from any streams
  void unsubscribeFromStreams() {
    _usersSubscription?.cancel();
    // Cancel other subscriptions if any
  }

}
