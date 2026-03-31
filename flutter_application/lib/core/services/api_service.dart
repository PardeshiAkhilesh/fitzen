import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final _storage = FlutterSecureStorage();
  static Dio? _dio;

  static Dio get dio {
    if (_dio != null) return _dio!;
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));

    return _dio!;
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'access_token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<dynamic> get(String path) async {
    final res = await dio.get(path);
    return res.data;
  }

  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
    debugPrint('API POST: ${ApiConstants.baseUrl}$path');
    debugPrint('API POST Body: $body');
    final res = await dio.post(path, data: body);
    debugPrint('API POST Response: ${res.data}');
    return res.data as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> put(
      String path, Map<String, dynamic> body) async {
    final res = await dio.put(path, data: body);
    return res.data as Map<String, dynamic>;
  }

  static Future<void> delete(String path) async {
    await dio.delete(path);
  }
}
