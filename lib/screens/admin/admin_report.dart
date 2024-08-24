import 'package:attendance_app/models/user_info.dart';
import 'package:attendance_app/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:month_year_picker/month_year_picker.dart';

class AdminReport extends StatefulWidget {
  const AdminReport({super.key});

  @override
  _AdminReportState createState() => _AdminReportState();
}

class _AdminReportState extends State<AdminReport> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showMonthYearPicker(context),
              child: Text('Select Month and Year'),
            ),
            Text(
                'Selected month: ${DateFormat.MMMM().format(selectedDate)}, year: ${selectedDate.year}'),
            Expanded(
              child: Consumer<FirestoreService>(
                builder: (context, firestoreService, child) {
                  Map<String, List<Employee>> usersWithTimeEntriesCache =
                      firestoreService.usersWithTimeEntriesCache;

                  if (usersWithTimeEntriesCache.isNotEmpty) {
                    List<Employee> usersWithTimeEntries =
                        usersWithTimeEntriesCache['allUsers'] ?? [];

                    return buildReport(usersWithTimeEntries);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMonthYearPicker(BuildContext context) async {
    final localeObj = Locale('en', 'US');
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: localeObj,
    );

    if (selected != null) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  Widget buildReport(List<Employee> usersWithTimeEntries) {
    List<Widget> report = [];

    int selectedMonth = selectedDate.month;
    int selectedYear = selectedDate.year;

    DateTime currentDate = DateTime.now();

    for (var user in usersWithTimeEntries) {
      var presentDays = 0;
      var absentDays = 0;


      var daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
      for (var day = 1; day <= daysInMonth; day++) {
        var date = DateTime(selectedYear, selectedMonth, day);
        // Check if it's a weekday
        if (date.weekday >= DateTime.monday && date.weekday <= DateTime.friday) {
          var foundEntry = user.timeEntries!.any((entry) {
            DateTime entryDateTime = entry.date!.toDate();
            return entryDateTime.day == date.day &&
                entryDateTime.month == date.month &&
                entryDateTime.year == date.year;
          });

          // Only count as absent if the day has passed AND it's past 5 PM
          if (!foundEntry && 
              date.isBefore(DateTime(currentDate.year, currentDate.month, currentDate.day, 17, 0, 0))) { 
            absentDays++;
          } else if (foundEntry) {
            presentDays++;
          }
        }
      }

      report.add(ListTile(
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text('Email: ${user.email}'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Present: $presentDays'),
            Text('Absent: $absentDays'),
          ],
        ),
      ));
    }

    if (report.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 100, color: Colors.grey),
            Text(
              'No records found for this month.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView(children: report);
  }
}
