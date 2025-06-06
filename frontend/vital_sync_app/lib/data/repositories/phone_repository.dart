// TODO Implement this library.
import 'package:vital_sync_app/data/models/phone_model.dart';
import '../../core/services/vital_sync_api_service.dart';

class PhoneRepository {
  final VitalSyncApiService apiService;

  PhoneRepository({required this.apiService});

  Future<List<Phone>> fetchPhone() async {
    final data = await apiService.get('phones');
    return data.map((json) => Phone.fromJson(json)).toList();
  }

  Future<Phone> fetchPhoneById(String id) async {
    final data = await apiService.get('phones/$id');
    return data.map((json) => Phone.fromJson(json)).first;
  }

  Future<Phone> createPhone(Phone phone) async {
    final data = await apiService.post('phones', phone.toJson());
    return Phone.fromJson(data);
  }
}
