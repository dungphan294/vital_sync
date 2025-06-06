// features/home/bloc/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_sync_app/data/repositories/data_repository.dart';
import 'package:vital_sync_app/features/home/bloc/home_event.dart';
import 'package:vital_sync_app/features/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DataRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadSensorData>(_loadData);
    on<RefreshSensorData>(_loadData);
  }

  Future<void> _loadData(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final records = await repository.searchData(userId: 'admin', limit: 1);
      if (records.isEmpty) {
        emit(HomeError(message: 'No data found'));
        return;
      }
      final latest = records.first;
      emit(
        HomeLoaded(
          heartRate: latest.heartRate,
          stepCount: latest.stepCounts,
          oxygenLevel: latest.oxygenSaturation.toDouble(),
          exerciseStreak: 0,
          caloriesBurned: 0,
        ),
      );
    } catch (_) {
      emit(HomeError(message: 'Failed to load data'));
    }
  }
}
