// models/vital_type_model.dart
import 'package:flutter/material.dart';

enum VitalType { heartRate, spo2, steps }

class VitalTypeModel {
  final VitalType type;
  final String label;
  final String unit;
  final IconData icon;
  final Color iconColor;

  VitalTypeModel({
    required this.type,
    required this.label,
    required this.unit,
    required this.icon,
    required this.iconColor,
  });

  static VitalTypeModel heartRate() => VitalTypeModel(
    type: VitalType.heartRate,
    label: "Heart Rate",
    unit: "bpm",
    icon: Icons.favorite_rounded,
    iconColor: const Color(0xFFFF6B6B),
  );

  static VitalTypeModel spo2() => VitalTypeModel(
    type: VitalType.spo2,
    label: "SpO2",
    unit: "%",
    icon: Icons.water_drop_rounded,
    iconColor: const Color.fromARGB(255, 0, 90, 226),
  );

  static VitalTypeModel steps() => VitalTypeModel(
    type: VitalType.steps,
    label: "Steps",
    unit: "",
    icon: Icons.directions_walk,
    iconColor: const Color.fromARGB(255, 28, 152, 32),
  );
}
