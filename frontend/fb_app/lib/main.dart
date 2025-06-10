// import 'package:fb_app/ble/ble_home.dart';
import 'package:fb_app/ble_scan.dart';
import 'package:flutter/material.dart';

// import 'ble_scan.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner',
      debugShowCheckedModeBanner: false,
      home: const BLEHome(),
    );
  }
}
