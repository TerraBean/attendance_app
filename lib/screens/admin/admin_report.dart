import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminReport extends StatefulWidget {
  const AdminReport({super.key});

  @override
  _AdminReportState createState() => _AdminReportState();
}

class _AdminReportState extends State<AdminReport> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // Sample Data
  List<Map<String, dynamic>> userData = [
    {
      'user': {
        'firstName': 'David',
        'lastName': 'Acheampong',
        'email': 'kokot@ymail.com'
      },
      'timeEntries': [
        {
          'date': DateTime.parse('2024-08-19'),
          'clockedIn': DateTime.parse('2024-08-19 08:30:00'),
          'clockedOut': DateTime.parse('2024-08-19 17:30:00'),
        },
        {
          'date': DateTime.parse('2024-08-20'),
          'clockedIn': DateTime.parse('2024-08-20 08:30:00'),
          'clockedOut': DateTime.parse('2024-08-20 17:30:00'),
        },
      ]
    },
    {
      'user': {
        'firstName': 'sjjssj',
        'lastName': 'sjshsh',
        'email': 'kokotoo@ymail.com'
      },
      'timeEntries': [
        {
          'date': DateTime.parse('2024-08-19'),
          'clockedIn': DateTime.parse('2024-08-19 08:30:00'),
          'clockedOut': DateTime.parse('2024-08-19 17:30:00'),
        },
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  showMonthPicker(context);
                },
                child: Text('Select Month')),
            Text('Selected month: $selectedMonth , year: $selectedYear'),
            Expanded(child: buildReport())
          ],
        ),
      ),
    );
  }

  void showMonthPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(selectedYear, selectedMonth),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      selectableDayPredicate: (DateTime val) =>
          val.day == 1, // allows selection of first day of month only
    );

    if (picked != null && (picked.year != selectedYear || picked.month != selectedMonth)) {
      setState(() {
        selectedYear = picked.year;
        selectedMonth = picked.month;
      });
    }
  }

  Widget buildReport() {
    List<Widget> report = [];

    for (var user in userData) {
      var presentDays = 0;
      var absentDays = 0;

      var daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
      for (var day = 1; day <= daysInMonth; day++) {
        var date = DateTime(selectedYear, selectedMonth, day);
        if (date.weekday >= DateTime.monday && date.weekday <= DateTime.friday) {
          var foundEntry = user['timeEntries'].any((entry) {
            return entry['date'].day == date.day &&
                entry['date'].month == date.month &&
                entry['date'].year == date.year;
          });

          if (foundEntry) {
            presentDays++;
          } else if (date.isBefore(DateTime.now()) || (date.isAtSameMomentAs(DateTime.now()) && DateTime.now().hour >= 17)) {
            absentDays++;
          }
        }
      }

      report.add(ListTile(
        title: Text('${user['user']['firstName']} ${user['user']['lastName']}'),
        subtitle: Text('Email: ${user['user']['email']}'),
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
