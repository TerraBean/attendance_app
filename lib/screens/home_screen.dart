// ignore_for_file: prefer_const_constructors

import 'package:attendance_app/screens/login.dart';
import 'package:attendance_app/screens/my_profile.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/widgets/clock_in_button.dart';
import 'package:attendance_app/widgets/clock_out_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LocationService _locationService;

  @override
  void initState() {
    super.initState();
    _locationService = Provider.of<LocationService>(context, listen: false);

    // Request location permission immediately on screen load
    _locationService.requestLocationPermission();
  }

  void onConfirmLogout() {
    // Navigate to LoginPage and remove all routes before it
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all routes until the root route
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock In/Out App'),
        actions: [
          // Add some spacing before the avatar
          SizedBox(width: 16), // Adjust the width as needed

          // Wrap the CircleAvatar in a GestureDetector to handle taps
          GestureDetector(
            onTap: () {
              // Navigate to ProfilePage when the avatar is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  Provider.of<FirestoreService>(context).currentEmployee!.firstName?.substring(0, 1) ?? 'A', // Replace with the first letter of the username
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<FirestoreService>(
        builder: (context, firebaseService, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome, ${firebaseService.currentEmployee?.firstName ?? 'User'}!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ClockInButton(),
                SizedBox(height: 20),
                ClockOutButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
