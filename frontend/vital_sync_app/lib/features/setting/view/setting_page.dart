import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // VitalSync icon can be added here if needed
            Image(
              image: AssetImage('assets/icon/icon.png'),
              width: 100,
              height: 100,
            ),
            SizedBox(height: 16),
            // App title and version
            Text(
              "Vital Sync",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Version 1.0.0"),
            SizedBox(height: 16),
            Text("This app helps you track heart rate, steps, and more."),
          ],
        ),
      ),
    );
  }
}
