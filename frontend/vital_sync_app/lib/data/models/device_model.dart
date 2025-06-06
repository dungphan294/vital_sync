class Device {
  final String serialNumber;
  final String model;
  final String deviceId;
  final DateTime createdTime;
  final DateTime updatedTime;

  Device({
    required this.serialNumber,
    required this.model,
    required this.deviceId,
    required this.createdTime,
    required this.updatedTime,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      serialNumber: json['serial_number'],
      model: json['model'],
      deviceId: json['device_id'],
      createdTime: DateTime.parse(json['created_time']),
      updatedTime: DateTime.parse(json['updated_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serial_number': serialNumber,
      'model': model,
      'device_id': deviceId,
      'created_time': createdTime.toIso8601String(),
      'updated_time': updatedTime.toIso8601String(),
    };
  }
}
