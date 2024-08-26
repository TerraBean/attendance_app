

import 'package:attendance_app/screens/admin/admin_dashboard.dart';
import 'package:attendance_app/screens/admin/admin_report.dart';
import 'package:attendance_app/screens/admin/admin_settings.dart';
import 'package:attendance_app/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboard(),
    // const AdminEmployeeManagement(),
    const AdminSettings(),
    const AdminReport()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Navigation'),
        actions: [
          SizedBox(width: 16,),
          ProfileAvatar()
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}