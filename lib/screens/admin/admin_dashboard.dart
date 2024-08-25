import 'package:attendance_app/screens/admin/total_card.dart';
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: SingleChildScrollView(
          // Make the content scrollable
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TotalCard(
                        title: "STAFF TOTAL",
                        count: _isLoading ? 0 : 0,
                        countColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TotalCard(
                        title: "TOTAL IN",
                        count: _isLoading ? 0 : 0,
                        countColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TotalCard(
                        title: "TOTAL OUT",
                        count: _isLoading ? 0 : 0,
                        countColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AttendanceTable()
            ],
          ),
        ),
      ),
    );
  }
}
