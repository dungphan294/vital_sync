// import 'dart:async';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class BluetoothService {
//   FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
//   final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;

//   Stream<List<BluetoothDevice>> get devices =>
//       _flutterBlue.connectedDevices.asStream();

//   Future<void> startScan() async {
//     _flutterBlue.startScan(timeout: const Duration(seconds: 4));
//   }

//   Future<void> stopScan() async {
//     _flutterBlue.stopScan();
//   }

//   Future<void> connectToDevice(BluetoothDevice device) async {
//     await device.connect();
//   }

//   Future<void> disconnectFromDevice(BluetoothDevice device) async {
//     await device.disconnect();
//   }
// }
