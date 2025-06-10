// viewmodels/vital_detail_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:vital_sync/models/vital_type_model.dart';

class VitalDetailViewModel extends ChangeNotifier {
  final VitalType _vitalType;
  final int? _currentValue;
  final VitalTypeModel _vitalTypeModel;

  VitalDetailViewModel({required VitalType vitalType, int? currentValue})
    : _vitalType = vitalType,
      _currentValue = currentValue,
      _vitalTypeModel = _getVitalTypeModel(vitalType);

  // Getters
  VitalType get vitalType => _vitalType;
  int? get currentValue => _currentValue;
  VitalTypeModel get vitalTypeModel => _vitalTypeModel;

  String get title => _vitalTypeModel.label;
  String get currentValueString => _currentValue?.toString() ?? "--";
  String get unit => _vitalTypeModel.unit;

  static VitalTypeModel _getVitalTypeModel(VitalType type) {
    switch (type) {
      case VitalType.heartRate:
        return VitalTypeModel.heartRate();
      case VitalType.spo2:
        return VitalTypeModel.spo2();
      case VitalType.steps:
        return VitalTypeModel.steps();
    }
  }
}
