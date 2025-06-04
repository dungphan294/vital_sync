// features/home/bloc/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/sensor_service.dart' as sensor_service;
import 'package:vital_sync_app/features/home/bloc/home_event.dart';
import 'package:vital_sync_app/features/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final sensor_service.SensorService sensorService;

  HomeBloc({required this.sensorService}) : super(HomeInitial()) {
    on<LoadSensorData>(_loadData);
    on<RefreshSensorData>(_loadData);
  }

  Future<void> _loadData(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final bpm = await sensorService.fetchHeartRate();
      final steps = await sensorService.fetchStepCount();
      emit(
        HomeLoaded(
          heartRate: bpm,
          stepCount: steps,
          oxygenLevel: 98.6,
          exerciseStreak: 5,
          caloriesBurned: 350,
        ),
      );
    } catch (_) {
      emit(HomeError(message: 'Failed to load data'));
    }
  }
}
