import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_sync_app/features/about/bloc/about_bloc.dart';
import 'package:vital_sync_app/features/about/bloc/about_event.dart';
import 'package:vital_sync_app/features/about/bloc/about_state.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AboutBloc()..add(LoadAppInfo()),
      child: Scaffold(
        appBar: AppBar(title: const Text('About Us')),
        body: BlocBuilder<AboutBloc, AboutState>(
          builder: (context, state) {
            if (state is AboutLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AboutLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Image.asset('assets/icon/logo.png'),
                    const SizedBox(height: 8),
                    Text("Version ${state.version}"),
                    const SizedBox(height: 16),
                    const Text(
                      "This app helps you track heart rate, steps, and more. The data is synced with your device for real-time monitoring.",
                    ),
                  ],
                ),
              );
            } else if (state is AboutError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink(); // Fallback for any other state
          },
        ),
      ),
    );
  }
}
