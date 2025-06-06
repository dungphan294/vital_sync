import 'package:vital_sync_app/data/models/workout_model.dart';
import '../../core/services/vital_sync_api_service.dart';

class WorkoutRepository {
  final VitalSyncApiService apiService;

  WorkoutRepository({required this.apiService});

  Future<List<Workout>> fetchUsers() async {
    final data = await apiService.get('workouts');
    return data.map((json) => Workout.fromJson(json)).toList();
  }
}
