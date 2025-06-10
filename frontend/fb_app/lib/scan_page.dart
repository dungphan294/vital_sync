// // scan_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'ble_service.dart';
// import 'device_details_page.dart';

// class ScanPage extends StatefulWidget {
//   const ScanPage({super.key});

//   @override
//   State<ScanPage> createState() => _ScanPageState();
// }

// class _ScanPageState extends State<ScanPage> {
//   final BleService _bleService = BleService();

//   @override
//   void initState() {
//     super.initState();
//     _startScan();
//   }

//   void _startScan() async {
//     await _bleService.startScan();
//   }

//   void _refreshScan() async {
//     await _bleService.stopScan();
//     await _bleService.startScan();
//   }

//   @override
//   void dispose() {
//     _bleService.stopScan();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('BLE Device Scanner'),
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshScan),
//         ],
//       ),
//       body: StreamBuilder<List<ScanResult>>(
//         stream: _bleService.scanResults,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final results = snapshot.data ?? [];
//           final filteredResults = results
//               .where((r) => r.device.platformName.isNotEmpty)
//               .toList();

//           if (filteredResults.isEmpty) {
//             return const Center(child: Text('No BLE devices found.'));
//           }

//           return ListView.builder(
//             itemCount: filteredResults.length,
//             itemBuilder: (context, index) {
//               final result = filteredResults[index];
//               return ListTile(
//                 leading: const Icon(Icons.bluetooth),
//                 title: Text(result.device.platformName),
//                 subtitle: Text(
//                   'ID: ${result.device.remoteId}\nRSSI: ${result.rssi}',
//                 ),
//                 trailing: const Icon(Icons.arrow_forward_ios),
//                 onTap: () async {
//                   await _bleService.connectToDevice(result.device);
//                   if (context.mounted) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             DeviceDetailsPage(device: result.device),
//                       ),
//                     );
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
