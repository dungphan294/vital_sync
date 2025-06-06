class UserPhone {
  final String userId;
  final String phoneId;
  final DateTime createdTime;
  final DateTime updatedTime;

  UserPhone({
    required this.userId,
    required this.phoneId,
    required this.createdTime,
    required this.updatedTime,
  });

  factory UserPhone.fromJson(Map<String, dynamic> json) {
    return UserPhone(
      userId: json['user_id'],
      phoneId: json['phone_id'],
      createdTime: DateTime.parse(json['created_time']),
      updatedTime: DateTime.parse(json['updated_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'phone_id': phoneId,
      'created_time': createdTime.toIso8601String(),
      'updated_time': updatedTime.toIso8601String(),
    };
  }
}
