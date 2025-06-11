// services/realtime_vital_service.dart
import 'dart:async';
import 'package:vital_sync/models/vital_type_model.dart';
import 'package:vital_sync/services/backend_api.dart';

class RealtimeVitalService {
  static final RealtimeVitalService _instance =
      RealtimeVitalService._internal();
  factory RealtimeVitalService() => _instance;
  RealtimeVitalService._internal();

  final BackendApi _backendApi = BackendApi();
  Timer? _timer;
  final Map<VitalType, int?> _currentValues = {};
  final Map<VitalType, List<Function(int?)>> _listeners = {};

  /// Get the current value for a specific vital type
  int? getCurrentValue(VitalType vitalType) {
    return _currentValues[vitalType];
  }

  /// Subscribe to real-time updates for a vital type
  void subscribe(VitalType vitalType, Function(int?) callback) {
    _listeners[vitalType] ??= [];
    _listeners[vitalType]!.add(callback);

    // Start polling if not already started
    _startPolling();
  }

  /// Unsubscribe from updates
  void unsubscribe(VitalType vitalType, Function(int?) callback) {
    _listeners[vitalType]?.remove(callback);

    // Stop polling if no more listeners
    if (_listeners.values.every((list) => list.isEmpty)) {
      _stopPolling();
    }
  }

  /// Fetch current vital value from backend
  Future<int?> fetchCurrentValue(VitalType vitalType) async {
    try {
      final response = await _backendApi.get(
        'realtime/current',
        queryParameters: {'vitalType': vitalType.toString()},
      );

      if (response is Map<String, dynamic> && response['value'] != null) {
        final value = response['value'] as int;
        _currentValues[vitalType] = value;
        _notifyListeners(vitalType, value);
        return value;
      }
    } catch (e) {
      print("Error fetching current vital value: $e");
      // Generate fallback value for demo
      // final value = _generateDemoValue(vitalType);
      // _currentValues[vitalType] = value;
      // _notifyListeners(vitalType, value);
      // return value;
    }
    return null;
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchAllActiveValues();
    });
  }

  void _stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetchAllActiveValues() async {
    for (final vitalType in _listeners.keys) {
      if (_listeners[vitalType]?.isNotEmpty == true) {
        await fetchCurrentValue(vitalType);
      }
    }
  }

  void _notifyListeners(VitalType vitalType, int? value) {
    final callbacks = _listeners[vitalType];
    if (callbacks != null) {
      for (final callback in callbacks) {
        callback(value);
      }
    }
  }

  // int _generateDemoValue(VitalType vitalType) {
  //   final now = DateTime.now();
  //   switch (vitalType) {
  //     case VitalType.heartRate:
  //       return 65 +
  //           (15 * (0.5 - (now.millisecondsSinceEpoch % 10000) / 10000)).round();
  //     case VitalType.spo2:
  //       return 96 +
  //           (3 * (0.5 - (now.millisecondsSinceEpoch % 8000) / 8000)).round();
  //     case VitalType.steps:
  //       return (now.hour * 600) + (now.minute * 10) + (now.second ~/ 6);
  //   }
  // }

  void dispose() {
    _stopPolling();
    _listeners.clear();
    _currentValues.clear();
  }
}
