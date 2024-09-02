// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:attendance_app/presentation/screens/login.dart';
import 'package:attendance_app/presentation/screens/my_profile.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/presentation/widgets/clock_in_button.dart';
import 'package:attendance_app/presentation/widgets/clock_out_button.dart';
import 'package:attendance_app/presentation/widgets/profile_avatar.dart';
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
          ProfileAvatar(),
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


