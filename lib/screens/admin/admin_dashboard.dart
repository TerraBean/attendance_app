import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/widgets/admin_card.dart';
import 'package:attendance_app/widgets/attendance_table';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _totalEmployees = 0;
  final int _totalClockedIn = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTotalEmployees();
    // No need to call _fetchTotalTimeEntries anymore
  }

  final firebaseService = FirestoreService();

  Future<void> _fetchTotalEmployees() async {
    try {
      final users = await firebaseService.getEmployees();
      setState(() {
        _totalEmployees = users.length;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ReusableCard(
            icon: Icons.person,
            title: "Total Employees",
            data: _isLoading
                ? '...' // Show "..." while loading
                : _totalEmployees.toString(),
          ),
          Row(
            children: [
              Expanded(
                child: Consumer<FirestoreService>(
                  builder: (context, firebaseService, child) {
                    // Get the time entries for today from the provider
                    // Map<String, List<Map<String, dynamic>>> timeEntries =
                    //     firebaseService.timeEntriesByUser;

                    // // Calculate the number of clocked-in employees
                    // _totalClockedIn = timeEntries
                    //     .where((entry) => entry['clockedOut'] == null)
                    //     .length;

                    return ReusableCard(
                      icon: Icons.access_time,
                      title: "Total In",
                      data: _isLoading
                          ? '...' // Show "..." while loading
                          : _totalClockedIn.toString(),
                    );
                  },
                ),
              ),
              // ... (Other widgets)
            ],
          ),
          AttendanceTable()
        ],
      ),
    );
  }
}
