class Data {
  final String workoutId;
  final int heartRate;
  final int oxygenSaturation;
  final int stepCounts;
  final DateTime timestamp;
  final String userId;
  final String phoneId;
  final String deviceId;

  Data({
    required this.workoutId,
    required this.heartRate,
    required this.oxygenSaturation,
    required this.stepCounts,
    required this.timestamp,
    required this.userId,
    required this.phoneId,
    required this.deviceId,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      workoutId: json['workout_id'],
      heartRate: json['heart_rate'],
      oxygenSaturation: json['oxygen_saturation'],
      stepCounts: json['step_counts'],
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['user_id'],
      phoneId: json['phone_id'],
      deviceId: json['device_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_id': workoutId,
      'heart_rate': heartRate,
      'oxygen_saturation': oxygenSaturation,
      'step_counts': stepCounts,
      'timestamp': timestamp.toIso8601String(),
      'user_id': userId,
      'phone_id': phoneId,
      'device_id': deviceId,
    };
  }
}
