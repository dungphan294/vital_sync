// viewmodels/vital_detail_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:vital_sync/models/vital_type_model.dart';
import 'package:vital_sync/services/vital_data_service.dart';

class VitalDetailViewModel extends ChangeNotifier {
  final VitalType _vitalType;
  int? _currentValue;
  final VitalTypeModel _vitalTypeModel;
  final RealtimeVitalService _realtimeService = RealtimeVitalService();

  VitalDetailViewModel({required VitalType vitalType, int? currentValue})
    : _vitalType = vitalType,
      _currentValue = currentValue,
      _vitalTypeModel = _getVitalTypeModel(vitalType) {
    _initializeRealTimeUpdates();
  }

  // Getters
  VitalType get vitalType => _vitalType;
  int? get currentValue => _currentValue;
  VitalTypeModel get vitalTypeModel => _vitalTypeModel;

  String get title => _vitalTypeModel.label;
  String get currentValueString => _currentValue?.toString() ?? "--";
  String get unit => _vitalTypeModel.unit;

  void _initializeRealTimeUpdates() {
    // Get initial value if not provided
    _currentValue ??= _realtimeService.getCurrentValue(_vitalType);

    // Subscribe to real-time updates
    _realtimeService.subscribe(_vitalType, _onValueUpdate);

    // Fetch latest value from backend
    _realtimeService.fetchCurrentValue(_vitalType);
  }

  void _onValueUpdate(int? value) {
    if (_currentValue != value) {
      _currentValue = value;
      notifyListeners();
    }
  }

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

  @override
  void dispose() {
    _realtimeService.unsubscribe(_vitalType, _onValueUpdate);
    super.dispose();
  }
}
