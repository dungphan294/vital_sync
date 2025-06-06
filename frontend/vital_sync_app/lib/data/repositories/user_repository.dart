import '../../core/services/vital_sync_api_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final VitalSyncApiService apiService;

  UserRepository({required this.apiService});

  Future<List<User>> fetchUsers() async {
    final data = await apiService.get('users');
    return data.map((json) => User.fromJson(json)).toList();
  }
}
