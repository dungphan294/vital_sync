class Workout {
  final DateTime startTime;
  final DateTime endTime;
  final String type;
  final String workoutId;
  final String userId;

  Workout({
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.workoutId,
    required this.userId,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      type: json['type'],
      workoutId: json['workout_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime.toIso8601String(),
      'end_time': startTime.toIso8601String(),
      'type': type,
      'workout_id': workoutId,
      'user_id': userId,
    };
  }
}
