import 'dart:convert';

class TimeEntry {
  final String id;
  final DateTime clockedIn;
  final DateTime? clockedOut;
  final String userId;

  TimeEntry({
    required this.id,
    required this.clockedIn,
    this.clockedOut,
    required this.userId,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      userId: json['user_id'],
      clockedIn: DateTime.parse(json['clocked_in']),
      clockedOut: json['clocked_out'] != null ? DateTime.parse(json['clocked_out']) : null,
    );
  }
}
