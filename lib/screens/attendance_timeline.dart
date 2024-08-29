import 'package:attendance_app/models/user_info.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:attendance_app/widgets/timeline_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceTimeline extends StatefulWidget {
  const AttendanceTimeline({Key? key}) : super(key: key);

  @override
  State<AttendanceTimeline> createState() => _AttendanceTimelineState();
}

class _AttendanceTimelineState extends State<AttendanceTimeline> {
  DateTime _selectedDate = DateTime.now(); // Currently selected date

  // Function to show the calendar popup
  void _showCalendarPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'),
          content: SizedBox(
            height: 400, // Adjust height as needed
            width: 400, // Adjust width as needed
            child: TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime(2023, 1, 1),
              lastDay: DateTime(2025, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Timeline',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF286DA8),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              _showCalendarPopup(context); // Show calendar on icon press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildTimeline(context, _selectedDate),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, DateTime selectedDate) {
    List usersWithTimeEntries = Provider.of<FirestoreService>(context)
            .usersWithTimeEntriesCache['allUsers'] ??
        [];

    List<Map<String, dynamic>> selectedDayEntries = [];

    String formattedDate =
        DateFormat('MMMM d, yyyy').format(selectedDate); // Format selected date

    for (var user in usersWithTimeEntries) {
      for (var entry in user.timeEntries) {
        DateTime entryDate = (entry.date as Timestamp).toDate();
        if (entryDate.year == selectedDate.year &&
            entryDate.month == selectedDate.month &&
            entryDate.day == selectedDate.day) {
          if (entry.clockedIn != null) {
            selectedDayEntries.add({
              'employeeFirstName': user.firstName,
              'employeeLastName': user.lastName,
              'time': entry.clockedIn,
              'type': 'Clock In',
            });
          }
          if (entry.clockedOut != null) {
            selectedDayEntries.add({
              'employeeFirstName': user.firstName,
              'employeeLastName': user.lastName,
              'time': entry.clockedOut,
              'type': 'Clock Out',
            });
          }
        }
      }
    }

    selectedDayEntries.sort((a, b) {
      DateTime aDate = (a['time'] as Timestamp).toDate();
      DateTime bDate = (b['time'] as Timestamp).toDate();
      return bDate.compareTo(aDate);
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            formattedDate,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: selectedDayEntries.isNotEmpty
              ? ListView.builder(
                  itemCount: selectedDayEntries.length,
                  itemBuilder: (context, index) {
                    var entry = selectedDayEntries[index];
                    String formattedTime = DateFormat('h:mm a')
                        .format((entry['time'] as Timestamp).toDate());

                    return TimelineTile(
                      time: formattedTime,
                      name:
                          '${entry['employeeFirstName'] != null ? entry['employeeFirstName'] : ''} ${entry['employeeLastName'] != null ? entry['employeeLastName'] : ''}',
                      type: entry['type'],
                      isLast: index == selectedDayEntries.length - 1,
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No entries found',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ),
      ],
    );
  }
}
