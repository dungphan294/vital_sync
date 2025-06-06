import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/vital_sync_api_service.dart';
import '../../../data/repositories/data_repository.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';
import '../../home/bloc/home_state.dart';
import '../../about/view/about_page.dart';
import '../view/widgets/sensor_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        repository: DataRepository(apiService: VitalSyncApiService()),
      )..add(LoadSensorData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vital Sync Homepage'),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  final sensorCards = [
                    SensorCard(
                      icon: Icons.favorite,
                      iconColor: Colors.red,
                      label: "Heart Rate",
                      labelColor: Colors.red,
                      value: "${state.heartRate} bpm",
                      actionButton: ElevatedButton.icon(
                        onPressed:
                            () => context.read<HomeBloc>().add(
                              RefreshSensorData(),
                            ),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                      ),
                    ),
                    SensorCard(
                      icon: Icons.directions_walk,
                      iconColor: Colors.blue,
                      label: "Step Count",
                      labelColor: Colors.blue,
                      value: "${state.stepCount} steps",
                      actionButton: ElevatedButton.icon(
                        onPressed:
                            () => context.read<HomeBloc>().add(
                              RefreshSensorData(),
                            ),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                      ),
                    ),
                    SensorCard(
                      icon: Icons.bubble_chart,
                      iconColor: Colors.green,
                      label: "Oxygen Level",
                      labelColor: Colors.green,
                      value: "${state.oxygenLevel}% O₂",
                      actionButton: ElevatedButton.icon(
                        onPressed:
                            () => context.read<HomeBloc>().add(
                              RefreshSensorData(),
                            ),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                      ),
                    ),
                    SensorCard(
                      icon: Icons.local_fire_department,
                      iconColor: Colors.orange,
                      label: "Exercise Streak",
                      labelColor: Colors.orange,
                      value: "${state.exerciseStreak} day streak",
                      actionButton: ElevatedButton.icon(
                        onPressed:
                            () => context.read<HomeBloc>().add(
                              RefreshSensorData(),
                            ),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                      ),
                    ),
                    SensorCard(
                      icon: Icons.local_fire_department,
                      iconColor: Colors.deepOrange,
                      label: "Calories Burned",
                      labelColor: Colors.deepOrange,
                      value: "${state.caloriesBurned} kcal",
                      actionButton: ElevatedButton.icon(
                        onPressed:
                            () => context.read<HomeBloc>().add(
                              RefreshSensorData(),
                            ),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                      ),
                    ),
                  ];

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isWide
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    sensorCards
                                        .map(
                                          (card) => Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: card,
                                            ),
                                          ),
                                        )
                                        .toList(),
                              )
                              : Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 16,
                                runSpacing: 16,
                                children: sensorCards,
                              ),
                          const SizedBox(height: 32),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 16,
                            children: [
                              ElevatedButton.icon(
                                onPressed:
                                    () => context.read<HomeBloc>().add(
                                      RefreshSensorData(),
                                    ),
                                icon: const Icon(Icons.refresh),
                                label: const Text("Refresh"),
                              ),
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
                },
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
