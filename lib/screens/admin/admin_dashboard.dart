import 'package:attendance_app/widgets/admin_card.dart';
import 'package:flutter/material.dart';
import 'package:attendance_app/services/user_api.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _totalEmployees = 0;
  int _totalClockedIn = 0;
  int _totalClockedOut = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTotalEmployees();
    _fetchTotalTimeEntries();
  }

  Future<void> _fetchTotalEmployees() async {
    try {
      final users = await UserApi.fetchUsers();
      setState(() {
        _totalEmployees = users.length;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching users: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchTotalTimeEntries() async {
    try {
      final timeEntries = await UserApi.fetchAllTimeEntries();
      // Count clocked-in and clocked-out entries
      _totalClockedIn = timeEntries.where((entry) => entry.clockedIn != null).length;
      _totalClockedOut = timeEntries.where((entry) => entry.clockedOut != null).length;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching time entries: $error');
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
                child: ReusableCard(
                  icon: Icons.access_time,
                  title: "Total In",
                  data: _isLoading
                      ? '...' // Show "..." while loading
                      : _totalClockedIn.toString(),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  icon: Icons.access_time,
                  title: "Total Out",
                  data: _isLoading
                      ? '...' // Show "..." while loading
                      : _totalClockedOut.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
