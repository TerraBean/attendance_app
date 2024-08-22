// class User{

//   final String username;
//   final String password;
//   // add other properties as needed

//   User({required this.username, required this.password});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       username: json['username'],
//       password: json['password'],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  final String username;
  final String password;

  Admin({required this.username, required this.password});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      username: json['username'],
      password: json['password'],
    );
  }
}

class UserOnline {
  final String username;
  final String password;

  UserOnline({required this.username, required this.password});
}

class LoginResponse {
  final String message;
  final String userId;
  final Map<String, dynamic>? user; // Assuming user object structure

  LoginResponse({required this.message, required this.userId, this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      userId: json['userId'],
      user: json['user'],
    );
  }
}

class Employee {
  String? uid; // Add the uid field
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? role;
  String? deviceId;
  String? staffNumber; // Staff number can be null
  List<TimeEntry>? timeEntries;

  Employee({
    this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.role,
    required this.deviceId,
    this.staffNumber,
    this.timeEntries,
  });

  // Factory constructor to create an Employee from a Map
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      uid: json['uid'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      deviceId: json['deviceId'],
      staffNumber: json['staffNumber'], // Handle null staffNumber
      // initialize timeEntries from the 'timeEntries' list in the JSON
      timeEntries: (json['timeEntries'] as List<dynamic>?)
          ?.map((e) => TimeEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert Employee to a Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'role': role,
      'deviceId': deviceId,
      'staffNumber': staffNumber,
      'timeEntries': timeEntries?.map((timeEntry) => timeEntry.toJson()).toList(),
    };
  }
}

class TimeEntry {
  String? id;
  Timestamp? clockedIn;
  Timestamp? clockedOut;
  Timestamp? date;

  TimeEntry({
    this.id,
    this.clockedIn,
    this.clockedOut,
    this.date,
  });

  // Constructor to create a TimeEntry object from a Map
  TimeEntry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clockedIn = json['clockedIn'] as Timestamp?;
    clockedOut = json['clockedOut'] as Timestamp?;
    date = json['date'] as Timestamp?;
  }

  // Method to convert TimeEntry object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clockedIn': clockedIn,
      'clockedOut': clockedOut,
      'date': date,
    };
  }

}
