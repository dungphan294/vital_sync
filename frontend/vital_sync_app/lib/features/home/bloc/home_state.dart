abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final int heartRate;
  final int stepCount;
  final double oxygenLevel;
  final int exerciseStreak;
  final int caloriesBurned;

  HomeLoaded({
    required this.heartRate,
    required this.stepCount,
    required this.oxygenLevel,
    required this.exerciseStreak,
    required this.caloriesBurned,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
