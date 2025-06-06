import '../../core/services/vital_sync_api_service.dart';
import '../models/data_model.dart';

class DataRepository {
  final VitalSyncApiService apiService;

  DataRepository({required this.apiService});

  /// Fetch a paginated list of data records for the given [userId].
  Future<List<Data>> searchData({
    required String userId,
    int page = 0,
    int limit = 100,
  }) async {
    final response = await apiService
        .get('data/search?user_id=$userId&page=$page&limit=$limit');

    if (response is Map<String, dynamic>) {
      final List<dynamic> list = response['data'] ?? [];
      return list.map((e) => Data.fromJson(e)).toList();
    }
    return [];
  }
}
