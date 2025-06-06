class Phone {
  final String serialNumber;
  final String model;
  final String os;
  final String phoneId;
  final DateTime createdTime;
  final DateTime updatedTime;

  Phone({
    required this.serialNumber,
    required this.model,
    required this.os,
    required this.phoneId,
    required this.createdTime,
    required this.updatedTime,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      serialNumber: json['serial_number'],
      model: json['model'],
      os: json['os'],
      phoneId: json['phone_id'],
      createdTime: DateTime.parse(json['created_time']),
      updatedTime: DateTime.parse(json['updated_time']),
    );
  }

  factory Phone.fromJsonWithId(Map<String, dynamic> json, String id) {
    return Phone(
      serialNumber: json['serial_number'],
      model: json['model'],
      os: json['os'],
      phoneId: id,
      createdTime: DateTime.parse(json['created_time']),
      updatedTime: DateTime.parse(json['updated_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serial_number': serialNumber,
      'model': model,
      'os': os,
      'phone_id': phoneId,
      'created_time': createdTime.toIso8601String(),
      'updated_time': updatedTime.toIso8601String(),
    };
  }
}
