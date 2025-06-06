import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadSensorData extends HomeEvent {
  const LoadSensorData();
}

class RefreshSensorData extends HomeEvent {
  const RefreshSensorData();
}
