// viewmodels/ble_home_viewmodel.dart
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:vital_sync/models/data_model.dart';
import 'package:vital_sync/services/backend_api.dart';
import 'dart:async';
import '../models/vital_signs_model.dart';
import '../models/device_connection_model.dart';
import '../models/vital_type_model.dart';
import '../services/ble_service.dart';

class HomeViewModel extends ChangeNotifier {
  final BLEService _bluetoothService = BLEService();

  StreamSubscription<VitalSignsModel>? _vitalSignsSubscription;
  StreamSubscription<DeviceConnectionModel>? _connectionSubscription;
  StreamSubscription<bool>? _fileNotifySubscription;
  StreamSubscription<Data>? _dataSubscription;
  bool _hasFileData = false;

  VitalSignsModel _vitalSigns = VitalSignsModel();
  DeviceConnectionModel _connectionState = DeviceConnectionModel(
    state: ConnectionState.disconnected,
  );

  // Getters
  VitalSignsModel get vitalSigns => _vitalSigns;
  DeviceConnectionModel get connectionState => _connectionState;
  bool get hasFileData => _hasFileData;
  bool get isConnected => _connectionState.isConnected;
  bool get isScanning => _connectionState.isScanning;
  bool get isDisconnected => _connectionState.isDisconnected;

  String get connectionStatusText {
    switch (_connectionState.state) {
      case ConnectionState.connected:
        return "Connected to ${_connectionState.deviceName ?? 'ESP32'}";
      case ConnectionState.scanning:
        return "Scanning for device...";
      case ConnectionState.connecting:
        return "Connecting...";
      case ConnectionState.disconnected:
        return "Disconnected";
    }
  }

  Color get connectionStatusColor {
    switch (_connectionState.state) {
      case ConnectionState.connected:
        return const Color(0xFF4CAF50); // Green
      case ConnectionState.scanning:
      case ConnectionState.connecting:
        return const Color(0xFFFF9800); // Orange
      case ConnectionState.disconnected:
        return const Color(0xFFF44336); // Red
    }
  }

  // Vital sign getters with proper formatting
  String get heartRateValue => _vitalSigns.heartRate?.toString() ?? "--";
  String get spo2Value => _vitalSigns.spo2?.toString() ?? "--";
  String get stepsValue => _vitalSigns.steps?.toString() ?? "--";

  int? getVitalValue(VitalType type) {
    switch (type) {
      case VitalType.heartRate:
        return _vitalSigns.heartRate;
      case VitalType.spo2:
        return _vitalSigns.spo2;
      case VitalType.steps:
        return _vitalSigns.steps;
    }
  }

  String getVitalValueString(VitalType type) {
    final value = getVitalValue(type);
    return value?.toString() ?? "--";
  }

  void initialize() {
    _subscribeToStreams();
    // _apiToStream();
    startScan();
  }

  // void _apiToStream() {
  //   _vitalSigns = VitalSignsModel(
  //     heartRate: data.heartRate,
  //     spo2: data.oxygenSaturation,
  //     steps: data.stepCounts,
  //   );
  //   notifyListeners();
  // }

  void _subscribeToStreams() {
    _vitalSignsSubscription = _bluetoothService.vitalSignsStream.listen((
      vitals,
    ) {
      _vitalSigns = vitals;
      BackendApi().post('/data/', {
        'heart_rate': vitals.heartRate,
        'oxygen_saturation': vitals.spo2,
        'step_counts': vitals.steps,
        'timestamp': vitals.timestamp.toIso8601String(),
        'user_id': 'admin', // Replace with actual user ID
        'phone_id': 'p001', // Replace with actual phone ID
        'device_id': 'd001', // Replace with actual device ID
        'workout_id': null, // Replace with actual workout ID
      });
      notifyListeners();
    });

    _connectionSubscription = _bluetoothService.connectionStream.listen((
      connection,
    ) {
      _connectionState = connection;
      notifyListeners();
    });

    _fileNotifySubscription = _bluetoothService.fileNotifyStream.listen((_) {
      _hasFileData = true;
      notifyListeners();
    });
  }

  Future<void> startScan() async {
    await _bluetoothService.startScan();
  }

  Future<void> disconnect() async {
    await _bluetoothService.disconnect();
  }

  void manualRefresh() {
    if (!isConnected && !isScanning) {
      startScan();
    }
  }

  @override
  void dispose() {
    _vitalSignsSubscription?.cancel();
    _connectionSubscription?.cancel();
    _fileNotifySubscription?.cancel();
    _bluetoothService.dispose();
    super.dispose();
  }
}
