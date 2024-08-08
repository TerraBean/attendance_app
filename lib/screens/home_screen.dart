import 'package:attendance_app/screens/login.dart';
import 'package:attendance_app/screens/settings_screen.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/widgets/center_location_display.dart';
import 'package:attendance_app/widgets/clock_in_button.dart';
import 'package:attendance_app/widgets/clock_out_button.dart';
import 'package:attendance_app/widgets/location_display.dart';
import 'package:attendance_app/widgets/logout_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String userId;
  const HomeScreen({super.key, required this.username, required this.userId});

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
    // Extract username from email
    String displayedUsername = widget.username.split('@')[0].toUpperCase();

    // Get the first letter of the username
    String firstLetter = displayedUsername.substring(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock In/Out App'),
        actions: [
          // Add some spacing before the avatar
          SizedBox(width: 16), // Adjust the width as needed
          // PopupMenuButton triggered by the avatar
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                  break;
                case 'logout':
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => LogoutConfirmationDialog(
                      onConfirmLogout: onConfirmLogout, // Pass the function
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 10),
                      Text('Settings'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
            child: // Avatar with first letter of username
            Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  firstLetter,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, $displayedUsername!'), // Display only the username
            const SizedBox(height: 20),
            ClockInButton(),
            SizedBox(height: 20),
            ClockOutButton(),
          ],
        ),
      ),
    );
  }
}
