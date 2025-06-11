import 'dart:io';

import 'package:dio/dio.dart';

class BackendApi {
  final baseUrl = 'http://87.212.41.104:8000';
  late final Dio _dio;

  BackendApi() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      // Handle different response data structures
      if (response.data is Map<String, dynamic>) {
        return response.data['data'] ??
            response.data['results'] ??
            response.data;
      } else if (response.data is List) {
        return response.data;
      } else {
        return response.data;
      }
    } catch (e) {
      print("Error fetching data: $e");
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      print("Error posting data: $e");
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.put(endpoint, data: data);
      return response.data;
    } catch (e) {
      print("Error updating data: $e");
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      Response response = await _dio.delete(endpoint);
      return response.data;
    } catch (e) {
      print("Error deleting data: $e");
      rethrow;
    }
  }
}
