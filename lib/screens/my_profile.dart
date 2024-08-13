// ignore_for_file: prefer_const_constructors

import 'package:attendance_app/screens/edit_profile.dart';
import 'package:attendance_app/screens/login.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // function to logout using AuthService logout function
  void logout() async {
    await AuthService().logout();
      if (!context.mounted) return;
    // After logout, navigate to LoginPage and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false, // Remove all routes until the root route
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Consumer<FirestoreService>(
        builder: (context, firebaseService, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/300'), // Replace with user's image URL
                ),
                const SizedBox(height: 10),
                Text(
                  firebaseService.currentEmployee?.firstName ?? 'N/A',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  firebaseService.currentEmployee?.email ?? 'N/A',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to EditProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                ProfileDetail(title: 'STAFF ID', value: 'EE 224478'),
                const Divider(),
                ProfileDetail(title: 'SSNIT NUMBER', value: '2277 6466 357'),
                const Divider(),
                ProfileDetail(title: 'PHONE', value: '0244 464 678'),
                const Divider(),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    // Implement income history functionality
                  },
                  child: const Text(
                    'INCOME HISTORY',
                    style:
                        TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 70),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          title: Column(
                            children: const [
                              Icon(Icons.logout, size: 50, color: Colors.red),
                              SizedBox(height: 10),
                              Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          content: const Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                // call logout function from authservice and navigate to LoginPage
                                logout();
                                // Use navigator to navigate to LoginPage
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => LoginPage()),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Yes, logout',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Closes the dialog
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'LOG OUT',
                    style:
                        TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String title;
  final String value;

  const ProfileDetail({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
