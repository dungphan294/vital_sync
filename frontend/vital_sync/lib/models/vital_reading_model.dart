class VitalReadingModel {
  String? id;
  String? patientId;
  String? type;
  double? value;
  DateTime? timestamp;

  VitalReadingModel({
    this.id,
    this.patientId,
    this.type,
    this.value,
    this.timestamp,
  });

  // Add methods for serialization, deserialization, etc. as needed
}
