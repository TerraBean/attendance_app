import 'package:flutter/material.dart';

class AttendanceTimeline extends StatelessWidget {
  final List<AttendanceEvent> events = [
    AttendanceEvent(time: '7:30 am', name: 'Adams Mujahid', type: 'Clock In'),
    AttendanceEvent(time: '7:44 am', name: 'Linda Baidoo', type: 'Clock In'),
    AttendanceEvent(time: '5:05 pm', name: 'Adams Mujahid', type: 'Clock Out'),
    AttendanceEvent(time: '5:00 pm', name: 'Linda Baidoo', type: 'Clock Out'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Timeline'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return TimelineTile(
              time: events[index].time,
              name: events[index].name,
              type: events[index].type,
              isLast: index == events.length - 1,
            );
          },
        ),
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  final String time;
  final String name;
  final String type;
  final bool isLast;

  const TimelineTile({
    required this.time,
    required this.name,
    required this.type,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isLast)
              Container(
                height: 60,
                width: 1,
                color: Colors.grey,
              ),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: type == 'Clock In' ? Colors.green : Colors.red,
              ),
            ),
            if (!isLast)
              Container(
                height: 60,
                width: 1,
                color: Colors.grey,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: type == 'Clock In' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Text(
                      type,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(name),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AttendanceEvent {
  final String time;
  final String name;
  final String type;

  AttendanceEvent({required this.time, required this.name, required this.type});
}
