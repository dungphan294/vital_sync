import '../../core/services/vital_sync_api_service.dart';
import '../models/device_model.dart';

class DeviceRepository {
  final VitalSyncApiService apiService;

  DeviceRepository({required this.apiService});

  Future<List<Device>> fetchUsers() async {
    final data = await apiService.get('users');
    return data.map((json) => Device.fromJson(json)).toList();
  }
}
