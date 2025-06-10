// import 'dart:async';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class BleException implements Exception {
//   final String message;
//   BleException(this.message);
// }

// class BleService {
//   // Stream of discovered devices
//   Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

//   // Stream of connected devices
//   Stream<List<BluetoothDevice>> get connectedDevices =>
//       Stream.value(FlutterBluePlus.connectedDevices);

//   Future<void> startScan() async {
//     await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
//   }

//   Future<void> stopScan() async {
//     await FlutterBluePlus.stopScan();
//   }

//   Future<void> connectToDevice(BluetoothDevice device) async {
//     try {
//       await device.disconnect();
//       await Future.delayed(const Duration(milliseconds: 1500));
//       await device.connect(
//         autoConnect: false,
//         timeout: const Duration(seconds: 15),
//       );
//       await device.discoverServices();
//     } catch (e) {
//       throw BleException('Failed to connect: $e');
//     }
//   }

//   Future<void> disconnectFromDevice(BluetoothDevice device) async {
//     await device.disconnect();
//   }

//   // Subscribe to characteristic notifications
//   Stream<List<int>> subscribeToCharacteristic(
//     BluetoothCharacteristic characteristic,
//   ) {
//     characteristic.setNotifyValue(true);
//     return characteristic.lastValueStream;
//   }

//   // Read characteristic value
//   Future<List<int>> readCharacteristic(
//     BluetoothCharacteristic characteristic,
//   ) async {
//     return await characteristic.read();
//   }

//   // Discover services for a device
//   Future<List<BluetoothService>> discoverServices(
//     BluetoothDevice device,
//   ) async {
//     return await device.discoverServices();
//   }

//   // Get characteristic from service
//   BluetoothCharacteristic? getCharacteristic(
//     BluetoothService service,
//     String characteristicUuid,
//   ) {
//     return service.characteristics.firstWhere(
//       (c) => c.uuid.toString() == characteristicUuid,
//     );
//   }
// }
