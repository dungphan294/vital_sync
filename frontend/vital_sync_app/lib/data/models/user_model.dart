class User {
  final String name;
  final String phoneNumber;
  final DateTime dob;
  final DateTime updatedTime;
  final String userId;
  final String username;
  final String password;
  final String email;
  final DateTime createdTime;

  User({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.dob,
    required this.updatedTime,
    required this.username,
    required this.password,
    required this.email,
    required this.createdTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      phoneNumber: json['phone_number'],
      dob: DateTime.parse(json['dob']),
      updatedTime: DateTime.parse(json['updated_time']),
      userId: json['user_id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      createdTime: DateTime.parse(json['created_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'dob': dob.toIso8601String(),
      'updated_time': updatedTime.toIso8601String(),
      'user_id': userId,
      'username': username,
      'password': password,
      'email': email,
      'created_time': createdTime.toIso8601String(),
    };
  }
}
