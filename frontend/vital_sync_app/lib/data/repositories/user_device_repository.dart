import 'package:vital_sync_app/data/models/user_device_model.dart';
import '../../core/services/vital_sync_api_service.dart';

class UserDeviceRepository {
  final VitalSyncApiService apiService;

  UserDeviceRepository({required this.apiService});

  Future<List<UserDevice>> fetchPhone() async {
    final data = await apiService.get('user-device');
    return data.map((json) => UserDevice.fromJson(json)).toList();
  }

  Future<UserDevice> fetchPhoneById(String user_id, String device_id) async {
    final data = await apiService.get('user-device/$user_id/$device_id');
    return data.map((json) => UserDevice.fromJson(json)).first;
  }

  Future<UserDevice> createPhone(UserDevice userDevice) async {
    final data = await apiService.post('user-device', userDevice.toJson());
    return UserDevice.fromJson(data);
  }
}
