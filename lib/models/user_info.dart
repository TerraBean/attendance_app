
class User{

  final String gender;
  final String email;
  final String phone;
  final UserName name;

  User({required this.gender, required this.email, required this.phone, required this.name});

  String get fullName{
    return '${name.title} ${name.first} ${name.last}';
  }
  
}

class UserName{
  final String title;
  final String first;
  final String last;

  UserName({required this.title,required this.first,required this.last});
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