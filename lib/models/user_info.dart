
class User{

  final String username;
  final String password;
  // add other properties as needed

  User({required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
    );
  }
}

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