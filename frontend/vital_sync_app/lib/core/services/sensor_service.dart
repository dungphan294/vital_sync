// core/services/sensor_service.dart

class SensorService {
  Future<int> fetchHeartRate() async =>
      Future.delayed(Duration(seconds: 1), () => 72);
  Future<int> fetchStepCount() async =>
      Future.delayed(Duration(seconds: 1), () => 1850);
}
