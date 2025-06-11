/// One row from the backend - all vitals taken at the same timestamp.
class VitalCombinedReading {
  final String? workoutId;
  final int heartRate;
  final int oxygenSaturation;
  final int? stepCounts;
  final DateTime timestamp;
  final String userId;
  final String phoneId;
  final String deviceId;

  VitalCombinedReading({
    required this.workoutId,
    required this.heartRate,
    required this.oxygenSaturation,
    required this.stepCounts,
    required this.timestamp,
    required this.userId,
    required this.phoneId,
    required this.deviceId,
  });

  factory VitalCombinedReading.fromJson(Map<String, dynamic> json) {
    return VitalCombinedReading(
      workoutId: json['workout_id'],
      heartRate: json['heart_rate'] ?? 0,
      oxygenSaturation: json['oxygen_saturation'] ?? 0,
      stepCounts: json['step_counts'],
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['user_id'],
      phoneId: json['phone_id'],
      deviceId: json['device_id'],
    );
  }

  Map<String, dynamic> toJson() => {
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
