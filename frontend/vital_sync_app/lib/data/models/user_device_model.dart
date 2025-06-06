class UserDevice {
  final String userId;
  final String deviceId;
  final DateTime createdTime;
  final DateTime updatedTime;

  UserDevice({
    required this.userId,
    required this.deviceId,
    required this.createdTime,
    required this.updatedTime,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      userId: json['user_id'],
      deviceId: json['device_id'],
      createdTime: DateTime.parse(json['created_time']),
      updatedTime: DateTime.parse(json['updated_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'device_id': deviceId,
      'created_time': createdTime.toIso8601String(),
      'updated_time': updatedTime.toIso8601String(),
    };
  }
}
