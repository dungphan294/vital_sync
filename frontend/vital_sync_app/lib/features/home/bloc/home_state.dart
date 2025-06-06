import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final int heartRate;
  final int stepCount;
  final double oxygenLevel;
  final int exerciseStreak;
  final int caloriesBurned;

  const HomeLoaded({
    required this.heartRate,
    required this.stepCount,
    required this.oxygenLevel,
    required this.exerciseStreak,
    required this.caloriesBurned,
  });

  @override
  List<Object?> get props =>
      [heartRate, stepCount, oxygenLevel, exerciseStreak, caloriesBurned];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
