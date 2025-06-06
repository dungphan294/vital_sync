import 'package:vital_sync_app/data/models/user_phone_model.dart';
import '../../core/services/vital_sync_api_service.dart';

class UserPhoneRepository {
  final VitalSyncApiService apiService;

  UserPhoneRepository({required this.apiService});

  Future<List<UserPhone>> fetchPhone() async {
    final data = await apiService.get('phones');
    return data.map((json) => UserPhone.fromJson(json)).toList();
  }

  Future<UserPhone> fetchPhoneById(String user_id, String phone_id) async {
    final data = await apiService.get('phones/$user_id/$phone_id');
    if (data.isEmpty) {
      throw Exception('Phone not found');
    }
    return data.map((json) => UserPhone.fromJson(json)).first;
  }

  Future<UserPhone> createPhone(UserPhone phone) async {
    final data = await apiService.post('phones', phone.toJson());
    return UserPhone.fromJson(data);
  }
}
