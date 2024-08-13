
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

class Admin{
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


class UserOnline{
  final String username;
  final String password;

  UserOnline({required this.username,required this.password});
}


class LoginResponse {
  final String message;
  final String userId;
  final Map<String, dynamic>? user; // Assuming user object structure

  LoginResponse({required this.message,required this.userId, this.user});

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

  Employee({
    this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.role,
    required this.deviceId,
    this.staffNumber,
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
    };
  }
}
