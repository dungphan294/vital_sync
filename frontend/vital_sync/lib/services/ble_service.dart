// services/bluetooth_service.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import '../models/vital_signs_model.dart';
import '../models/device_connection_model.dart';
import 'backend_api.dart';

class BLEService {
  // ignore: constant_identifier_names
  static const String TARGET_DEVICE_NAME = "ESP32 Fitness Band";

  // BLE UUIDs
  // ignore: non_constant_identifier_names
  static final Guid PLX_SERVICE_UUID = Guid(
    "00001822-0000-1000-8000-00805F9B34FB",
  );
  // ignore: non_constant_identifier_names
  static final Guid PLX_CHAR_UUID = Guid(
    "00002A5F-0000-1000-8000-00805F9B34FB",
  );
  // ignore: non_constant_identifier_names
  static final Guid STEP_SERVICE_UUID = Guid(
    "0000FF10-0000-1000-8000-00805F9B34FB",
  );
  // ignore: non_constant_identifier_names
  static final Guid STEP_CHAR_UUID = Guid(
    "0000FF11-0000-1000-8000-00805F9B34FB",
  );

  // ignore: non_constant_identifier_names
  static final Guid FILE_SERVICE_UUID = Guid(
    "12345678-1234-5678-1234-56789ABCDEF0",
  );

  // ignore: non_constant_identifier_names
  static final Guid FILE_CHAR_UUID = Guid(
    "ABCDEF01-2345-6789-ABCD-EF0123456789",
  );

  // Singleton instance
  static final BLEService _instance = BLEService._internal();
  factory BLEService() => _instance;
  BLEService._internal();

  BluetoothDevice? _device;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  Timer? _scanTimer;
  Timer? _reconnectTimer;
  bool _isScanning = false;
  bool _disposed = false;

  // Streams for data updates
  final StreamController<VitalSignsModel> _vitalSignsController =
      StreamController<VitalSignsModel>.broadcast();
  final StreamController<DeviceConnectionModel> _connectionController =
      StreamController<DeviceConnectionModel>.broadcast();
  final StreamController<bool> _fileNotifyController =
      StreamController<bool>.broadcast();

  Stream<VitalSignsModel> get vitalSignsStream => _vitalSignsController.stream;
  Stream<DeviceConnectionModel> get connectionStream =>
      _connectionController.stream;
  Stream<bool> get fileNotifyStream => _fileNotifyController.stream;

  VitalSignsModel _currentVitals = VitalSignsModel();
  DeviceConnectionModel _connectionState = DeviceConnectionModel(
    state: ConnectionState.disconnected,
  );

  VitalSignsModel get currentVitals => _currentVitals;
  DeviceConnectionModel get connectionState => _connectionState;

  void dispose() {
    _disposed = true;
    _scanTimer?.cancel();
    _reconnectTimer?.cancel();
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    _vitalSignsController.close();
    _connectionController.close();
    _fileNotifyController.close();
    FlutterBluePlus.stopScan();
    _device?.disconnect();
  }

  Future<void> initialize() async {
    if (_disposed) return;

    // Check if Bluetooth is available
    if (!await FlutterBluePlus.isSupported) {
      _updateConnectionState(
        ConnectionState.disconnected,
        errorMessage: "Bluetooth not available",
      );
      return;
    }

    // Check if Bluetooth is on
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      _updateConnectionState(
        ConnectionState.disconnected,
        errorMessage: "Bluetooth is turned off",
      );
      return;
    }

    startScan();
  }

  Future<void> startScan() async {
    if (_disposed ||
        _isScanning ||
        _connectionState.state == ConnectionState.connected) {
      return;
    }

    _isScanning = true;
    _updateConnectionState(ConnectionState.scanning);

    try {
      // Stop any existing scan
      await FlutterBluePlus.stopScan();

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 5),
        androidUsesFineLocation: false,
      );

      _scanSubscription?.cancel();
      _scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          for (ScanResult result in results) {
            if (result.device.platformName == TARGET_DEVICE_NAME) {
              // ignore: avoid_print
              print("Found target device: ${result.device.platformName}");
              FlutterBluePlus.stopScan();
              _isScanning = false;
              _connectToDevice(result.device);
              return;
            }
          }
        },
        onError: (error) {
          // ignore: avoid_print
          print("Scan error: $error");
          _handleScanError(error);
        },
      );

      // Set up timer to restart scan if device not found
      _scanTimer?.cancel();
      _scanTimer = Timer(const Duration(seconds: 12), () {
        if (!_disposed && _connectionState.state != ConnectionState.connected) {
          // ignore: avoid_print
          print("Scan timeout, restarting scan...");
          _isScanning = false;
          _restartScanAfterDelay();
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print("Start scan error: $e");
      _isScanning = false;
      _updateConnectionState(
        ConnectionState.disconnected,
        errorMessage: "Scan failed: ${e.toString()}",
      );
      _restartScanAfterDelay();
    }
  }

  void _handleScanError(dynamic error) {
    _isScanning = false;
    _updateConnectionState(
      ConnectionState.disconnected,
      errorMessage: "Scan error: ${error.toString()}",
    );
    _restartScanAfterDelay();
  }

  void _restartScanAfterDelay() {
    if (_disposed) return;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_disposed) {
        startScan();
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    if (_disposed) return;

    try {
      _device = device;
      _updateConnectionState(
        ConnectionState.connecting,
        deviceName: device.platformName,
      );

      // Connect with timeout
      await _device!.connect(timeout: const Duration(seconds: 15));

      _updateConnectionState(
        ConnectionState.connected,
        deviceName: device.platformName,
        deviceId: device.remoteId.toString(),
      );

      _scanTimer?.cancel();
      _reconnectTimer?.cancel();

      // Listen for disconnection
      _connectionSubscription?.cancel();
      _connectionSubscription = _device!.connectionState.listen(
        (state) {
          // ignore: avoid_print
          print("Connection state changed: $state");
          if (state == BluetoothConnectionState.disconnected) {
            _handleDisconnection();
          }
        },
        onError: (error) {
          // ignore: avoid_print
          print("Connection state error: $error");
          _handleDisconnection();
        },
      );

      await _discoverServices();
    } catch (e) {
      // ignore: avoid_print
      print("Connection failed: $e");
      _updateConnectionState(
        ConnectionState.disconnected,
        errorMessage: "Connection failed: ${e.toString()}",
      );
      _device = null;
      _restartScanAfterDelay();
    }
  }

  void _handleDisconnection() {
    if (_disposed) return;
    // ignore: avoid_print
    print("Device disconnected, restarting scan...");
    _updateConnectionState(ConnectionState.disconnected);
    _updateVitalSigns(VitalSignsModel()); // Clear vital signs
    _device = null;
    _restartScanAfterDelay();
  }

  Future<void> _discoverServices() async {
    if (_disposed || _device == null) return;

    try {
      List<BluetoothService> services = await _device!.discoverServices();
      // ignore: avoid_print
      print("Discovered ${services.length} services");

      for (var service in services) {
        // ignore: avoid_print
        print("Service UUID: ${service.uuid}");

        if (service.uuid == PLX_SERVICE_UUID) {
          await _setupPulseOximeterService(service);
        }

        if (service.uuid == STEP_SERVICE_UUID) {
          await _setupStepCounterService(service);
        }

        if (service.uuid == FILE_SERVICE_UUID) {
          // Handle file transfer service if needed
          // ignore: avoid_print
          print("File transfer service found, but not implemented yet");
          await _setupFileTransferService(service);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print("Service discovery error: $e");
      _updateConnectionState(
        ConnectionState.connected,
        errorMessage: "Service discovery failed: ${e.toString()}",
      );
    }
  }

  Future<void> _setupPulseOximeterService(BluetoothService service) async {
    try {
      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid == PLX_CHAR_UUID,
        orElse: () => throw Exception("PLX characteristic not found"),
      );
      // ignore: avoid_print
      print("Setting up pulse oximeter notifications");
      await characteristic.setNotifyValue(true);

      characteristic.onValueReceived.listen(
        (value) {
          if (_disposed) return;
          // ignore: avoid_print
          print(
            "PLX data received: ${value.map((e) => e.toRadixString(16)).join(' ')}",
          );

          if (value.length >= 5) {
            final spo2 = _decodeSfloat(value[1], value[2]);
            final heartRate = _decodeSfloat(value[3], value[4]);
            // ignore: avoid_print
            print("SpO2: $spo2, HR: $heartRate");

            _updateVitalSigns(
              _currentVitals.copyWith(spo2: spo2, heartRate: heartRate),
            );
          }
        },
        onError: (error) {
          // ignore: avoid_print
          print("PLX characteristic error: $error");
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print("Error setting up pulse oximeter service: $e");
    }
  }

  Future<void> _setupStepCounterService(BluetoothService service) async {
    try {
      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid == STEP_CHAR_UUID,
        orElse: () => throw Exception("Step characteristic not found"),
      );
      // ignore: avoid_print
      print("Setting up step counter notifications");
      await characteristic.setNotifyValue(true);

      characteristic.onValueReceived.listen(
        (value) {
          if (_disposed) return;
          // ignore: avoid_print
          print(
            "Step data received: ${value.map((e) => e.toRadixString(16)).join(' ')}",
          );

          if (value.length >= 2) {
            final steps = value[0] + (value[1] << 8);
            // ignore: avoid_print
            print("Steps: $steps");

            _updateVitalSigns(_currentVitals.copyWith(steps: steps));
          }
        },
        onError: (error) {
          // ignore: avoid_print
          print("Step characteristic error: $error");
        },
      );
    } catch (e) {
      // ignore: avoid_print
      print("Error setting up step counter service: $e");
    }
  }

  int _decodeSfloat(int low, int high) {
    int raw = (high << 8) | low;
    int mantissa = raw & 0x0FFF;
    if ((mantissa & 0x0800) != 0) mantissa |= 0xF000; // sign extend
    return mantissa;
  }

  void _updateConnectionState(
    ConnectionState state, {
    String? deviceName,
    String? deviceId,
    String? errorMessage,
  }) {
    if (_disposed) return;

    _connectionState = _connectionState.copyWith(
      state: state,
      deviceName: deviceName,
      deviceId: deviceId,
      errorMessage: errorMessage,
    );
    _connectionController.add(_connectionState);
  }

  void _updateVitalSigns(VitalSignsModel vitals) {
    if (_disposed) return;

    _currentVitals = vitals;
    _vitalSignsController.add(_currentVitals);
  }

  Future<void> disconnect() async {
    _scanTimer?.cancel();
    _reconnectTimer?.cancel();
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();

    if (_device != null) {
      try {
        await _device!.disconnect();
      } catch (e) {
        // ignore: avoid_print
        print("Disconnect error: $e");
      }
    }

    _device = null;
    _updateConnectionState(ConnectionState.disconnected);
    _updateVitalSigns(VitalSignsModel());
  }

  Future<void> reconnect() async {
    await disconnect();
    await Future.delayed(const Duration(seconds: 1));
    startScan();
  }

  final _buffer = BytesBuilder();

  Future<void> _setupFileTransferService(BluetoothService service) async {
    final characteristic = service.characteristics.firstWhere(
      (c) => c.uuid == FILE_CHAR_UUID,
    );

    await characteristic.setNotifyValue(true, timeout: 60);
    characteristic.onValueReceived.listen((value) async {
      if (value.isEmpty) {
        // EOF — we have the full file
        final bytes = _buffer.takeBytes();
        _buffer.clear();

        final jsonStr = utf8.decode(bytes);
        // Optional: validate JSON here
        await _sendToServer(jsonStr);
        _fileNotifyController.add(true);
      } else {
        _buffer.add(value);
      }
    });
  }

  Future<void> _sendToServer(String json) async {
    BackendApi api = BackendApi();
    try {
      // Validate JSON format
      final parsedJson = jsonDecode(json);
      if (parsedJson is! Map<String, dynamic>) {
        throw FormatException("Invalid JSON format");
      }
      // Convert to JSON string
      final jsonData = jsonEncode(parsedJson);

      // Send the JSON data to the server
      await api.post('/data/', {'data': jsonData});
      // ignore: avoid_print
      print("Data uploaded successfully");
    } catch (e) {
      // ignore: avoid_print
      print("Error uploading data: $e");
      // Optionally, handle retry logic here
    }
  }
}
