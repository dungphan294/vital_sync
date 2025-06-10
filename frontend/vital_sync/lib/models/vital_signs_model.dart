// models/vital_signs_model.dart
class VitalSignsModel {
  final int? spo2;
  final int? heartRate;
  final int? steps;
  final DateTime timestamp;

  VitalSignsModel({this.spo2, this.heartRate, this.steps, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  VitalSignsModel copyWith({
    int? spo2,
    int? heartRate,
    int? steps,
    DateTime? timestamp,
  }) {
    return VitalSignsModel(
      spo2: spo2 ?? this.spo2,
      heartRate: heartRate ?? this.heartRate,
      steps: steps ?? this.steps,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spo2': spo2,
      'heartRate': heartRate,
      'steps': steps,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory VitalSignsModel.fromJson(Map<String, dynamic> json) {
    return VitalSignsModel(
      spo2: json['spo2'],
      heartRate: json['heartRate'],
      steps: json['steps'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
