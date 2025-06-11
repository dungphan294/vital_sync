class Data {
  final String workoutId;
  final int heartRate;
  final int oxygenSaturation;
  final int stepCounts;
  final String timestamp;
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
      timestamp: json['timestamp'],
      userId: json['user_id'],
      phoneId: json['phone_id'],
      deviceId: json['device_id'],
    );
  }
}

class DataResponse {
  final int total;
  final int totalPages;
  final int currentPage;
  final int limit;
  final List<Data> data;

  DataResponse({
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.data,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      total: json['total'],
      totalPages: json['total_pages'],
      currentPage: json['current_page'],
      limit: json['limit'],
      data: (json['data'] as List).map((item) => Data.fromJson(item)).toList(),
    );
  }
}
