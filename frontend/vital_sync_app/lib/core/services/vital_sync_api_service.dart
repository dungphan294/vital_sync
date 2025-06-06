import 'package:dio/dio.dart';
import '../constants/config.dart';

class VitalSyncApiService {
  final Config config = Config();
  late final Dio _dio;

  VitalSyncApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.vitalSyncApiUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );
  }

  Future<List<dynamic>> get(String endpoint) async {
    try {
      Response response = await _dio.get("$endpoint/");
      return response.data;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post("$endpoint/", data: data);
      return response.data;
    } catch (e) {
      print("Error posting data: $e");
      return null;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.put("$endpoint/", data: data);
      return response.data;
    } catch (e) {
      print("Error updating data: $e");
      return null;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      Response response = await _dio.delete("$endpoint/");
      return response.data;
    } catch (e) {
      print("Error deleting data: $e");
      return null;
    }
  }
}
