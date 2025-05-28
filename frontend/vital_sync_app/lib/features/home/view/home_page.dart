import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/sensor_service.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';
import '../../home/bloc/home_state.dart';
import '../../about/view/about_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              HomeBloc(sensorService: SensorService())..add(LoadSensorData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('VitalSync Dashboard'),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "❤️ Heart Rate",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "${state.heartRate} bpm",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "👣 Step Count",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "${state.stepCount}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed:
                                () => context.read<HomeBloc>().add(
                                  RefreshSensorData(),
                                ),
                            icon: const Icon(Icons.refresh),
                            label: const Text("Refresh"),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AboutPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.info_outline),
                            label: const Text("About"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const Center(child: Text("Welcome to VitalSync"));
          },
        ),
      ),
    );
  }
}
