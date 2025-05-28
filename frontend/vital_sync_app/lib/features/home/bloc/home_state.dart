abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final int heartRate;
  final int stepCount;

  HomeLoaded({required this.heartRate, required this.stepCount});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
