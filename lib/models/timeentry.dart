class TimeEntry {
  final int id; // Add id to the model
  final String userId;
  final DateTime clockedIn;
  final DateTime? clockedOut; // Make clockedOut nullable

  TimeEntry({
    required this.id, // Include id in the constructor
    required this.userId,
    required this.clockedIn,
    this.clockedOut,
  });

  // Factory constructor to create a TimeEntry from a Map
  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'], // Get id from the JSON
      userId: json['user_id'],
      clockedIn: DateTime.parse(json['clocked_in']),
      clockedOut: json['clocked_out'] != null
          ? DateTime.parse(json['clocked_out'])
          : null,
    );
  }
}