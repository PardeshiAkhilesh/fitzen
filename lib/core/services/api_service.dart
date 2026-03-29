import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  final Dio _dio;
  final StorageService _storageService;

  ApiService(this._storageService)
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Attempt refresh logic here or clear session
          await _storageService.deleteToken();
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    // For now we mock calls since the real backend is not specified
    throw UnimplementedError("API integration not implemented. Use mock data.");
  }

  Future<Response> post(String path, {dynamic data}) {
    throw UnimplementedError("API integration not implemented. Use mock data.");
  }
}
