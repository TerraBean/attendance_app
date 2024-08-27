import 'package:attendance_app/models/user_info.dart'; 
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/widgets/timeline_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 

class AttendanceTimeline extends StatefulWidget {
  const AttendanceTimeline({Key? key}) : super(key: key);

  @override
  State<AttendanceTimeline> createState() => _AttendanceTimelineState();
}

class _AttendanceTimelineState extends State<AttendanceTimeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Timeline'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildTimeline(context),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    List usersWithTimeEntries = Provider.of<FirestoreService>(context)
            .usersWithTimeEntriesCache['allUsers'] ??
        [];

    List<Map<String, dynamic>> todaysEntries = [];
    DateTime now = DateTime.now();

    for (var user in usersWithTimeEntries) {
      for (var entry in user.timeEntries) {
        DateTime entryDate = (entry.date as Timestamp).toDate();
        if (entryDate.year == now.year &&
            entryDate.month == now.month &&
            entryDate.day == now.day) {
          // Add clock in entry
          if (entry.clockedIn != null) {
            todaysEntries.add({
              'employeeFirstName': user.firstName,
              'employeeLastName': user.lastName,
              'time': entry.clockedIn,
              'type': 'Clock In',
            });
          }

          // Add clock out entry
          if (entry.clockedOut != null) {
            todaysEntries.add({
              'employeeFirstName': user.firstName,
              'employeeLastName': user.lastName,
              'time': entry.clockedOut,
              'type': 'Clock Out',
            });
          }
        }
      }
    }

    // 2. Sort chronologically (most recent first)
    todaysEntries.sort((a, b) {
      DateTime aDate = (a['time'] as Timestamp).toDate();
      DateTime bDate = (b['time'] as Timestamp).toDate();
      return bDate.compareTo(aDate);
    });

    // 3. Build the timeline
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: todaysEntries.length,
            itemBuilder: (context, index) {
              var entry = todaysEntries[index];
              String formattedTime = DateFormat('h:mm a')
                  .format((entry['time'] as Timestamp).toDate());

              return TimelineTile(
                time: formattedTime,
                name:
                    '${entry['employeeFirstName'] != null ? entry['employeeFirstName'] : ''} ${entry['employeeLastName'] != null ? entry['employeeLastName'] : ''}',
                type: entry['type'], 
                isLast: index == todaysEntries.length - 1,
              );
            },
          ),
        ),
      ],
    );
  }
}
