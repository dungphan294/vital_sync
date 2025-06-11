// main.dart
import 'package:flutter/material.dart';
// import 'package:vital_sync/views/home_view.dart';
import 'main_navigation_scaffold.dart';
import 'views/profile_view.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitalSync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainNavigationScaffold(),
      routes: {'/profile': (context) => const ProfileView()},
    );
  }
}
