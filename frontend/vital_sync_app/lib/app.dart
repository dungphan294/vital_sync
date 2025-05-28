import 'package:flutter/material.dart';
import 'features/home/view/home_page.dart';

/// {@template vital_sync_app}
/// VitalSync App
/// Flutter application for managing health data.
/// Group 8, Project Integration, Applied Computer Science 23-27,
/// Saxion University of Applied Sciences
/// {@endtemplate}
class VitalSyncApp extends StatelessWidget {
  /// Creates a new instance of [VitalSyncApp].
  const VitalSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitalSync',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
