class TimeEntry {
  final String id;
  final String userId;
  final DateTime _clockedIn;
  final DateTime? _clockedOut;

  DateTime get clockedIn => _clockedIn;
  DateTime? get clockedOut => _clockedOut;

  TimeEntry({
    required this.id,
    required DateTime clockedIn,
    DateTime? clockedOut,
    required this.userId,
  })  : _clockedIn = clockedIn,
        _clockedOut = clockedOut;

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      userId: json['user_id'],
      clockedIn: DateTime.parse(json['clocked_in']),
      clockedOut: json['clocked_out'] != null ? DateTime.parse(json['clocked_out']) : null,
    );
  }
}
