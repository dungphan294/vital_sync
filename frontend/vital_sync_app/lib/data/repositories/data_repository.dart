import '../../core/services/vital_sync_api_service.dart';
import '../models/data_model.dart';

class DataRepository {
  final VitalSyncApiService apiService;

  DataRepository({required this.apiService});

  Future<List<Data>> fetchUsers() async {
    final data = await apiService.get('users');
    return data.map((json) => Data.fromJson(json)).toList();
  }
}
