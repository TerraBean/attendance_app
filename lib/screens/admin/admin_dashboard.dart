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
  int _totalClockedIn = 0;
  int _totalClockedOut = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTotalEmployeesAndAttendance();
  }

Future<void> _fetchTotalEmployeesAndAttendance() async {
  final firebaseService =
      Provider.of<FirestoreService>(context, listen: false);
  await firebaseService.fetchUsersWithTimeEntries();

  setState(() {
    _isLoading = true;
  });

  try {
    final usersWithTimeEntries =
        firebaseService.usersWithTimeEntriesCache['allUsers'] ?? [];
    _totalEmployees = usersWithTimeEntries.length;

    final now = DateTime.now();

    for (var user in usersWithTimeEntries) {
      // Ensure timeEntries is not null before iterating
      if (user.timeEntries != null) { 
        for (var timeEntry in user.timeEntries!) { 
          // Convert Timestamp to DateTime
          DateTime? clockedIn = timeEntry.clockedIn?.toDate();
          DateTime? clockedOut = timeEntry.clockedOut?.toDate();

          // Check if the date components match for clockedIn
          if (clockedIn != null && 
              DateTime(clockedIn.year, clockedIn.month, clockedIn.day) == 
              DateTime(now.year, now.month, now.day)) {
            _totalClockedIn++;
          }

          // Check if the date components match for clockedOut
          if (clockedOut != null &&
              DateTime(clockedOut.year, clockedOut.month, clockedOut.day) == 
              DateTime(now.year, now.month, now.day)) {
            _totalClockedOut++;
          }
        }
      }
    }
  } catch (error) {
    print('Error calculating attendance: $error');
  }

  setState(() {
    _isLoading = false;
  });
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
                        count: _isLoading ? 0 : _totalEmployees,
                        countColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TotalCard(
                        title: "TOTAL IN",
                        count: _isLoading ? 0 : _totalClockedIn,
                        countColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TotalCard(
                        title: "TOTAL OUT",
                        count: _isLoading ? 0 : _totalClockedOut,
                        countColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: AdminCard(
                      title: "Attendance Timeline",
                      icon: Icons.check_circle_outline, // Use the appropriate icon
                      onTap: () {
                        // Navigate to AttendanceTimeline page
                        Navigator.pushNamed(context, '/attendance-timeline');
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: AdminCard(
                      title: "Access Management",
                      icon: Icons.person_add, // Use the appropriate icon
                      onTap: () {
                        // Navigate to Employee Management page
                        Navigator.pushNamed(context, '/employee-management');
                      },
                    ),
                  ),
                ],
              ),
              AttendanceTable()
            ],
          ),
        ),
      ),
    );
  }
}
