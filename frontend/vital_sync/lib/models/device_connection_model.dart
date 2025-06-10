// models/device_connection_model.dart
enum ConnectionState { disconnected, scanning, connecting, connected }

class DeviceConnectionModel {
  final ConnectionState state;
  final String? deviceName;
  final String? deviceId;
  final String? errorMessage;

  DeviceConnectionModel({
    required this.state,
    this.deviceName,
    this.deviceId,
    this.errorMessage,
  });

  DeviceConnectionModel copyWith({
    ConnectionState? state,
    String? deviceName,
    String? deviceId,
    String? errorMessage,
  }) {
    return DeviceConnectionModel(
      state: state ?? this.state,
      deviceName: deviceName ?? this.deviceName,
      deviceId: deviceId ?? this.deviceId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isConnected => state == ConnectionState.connected;
  bool get isScanning => state == ConnectionState.scanning;
  bool get isConnecting => state == ConnectionState.connecting;
  bool get isDisconnected => state == ConnectionState.disconnected;
}
