import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../utils/token_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Dio get dio => _dio;
  late final Dio _dio;
  final TokenStorage _tokenStorage = TokenStorage(const FlutterSecureStorage());

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException err, handler) async {
        if (err.response?.statusCode == 401) {
          await _tokenStorage.deleteAll();
          // Navigate to login — use your app's navigator key or provider
        }
        return handler.next(err);
      },
    ));
  }

  Future<Response> get(String endpoint) async {
    return _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    return _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    return _dio.delete(endpoint);
  }

  Future<Response> uploadFile(
    String endpoint,
    String filePath,
    String fileName, {
    Map<String, dynamic>? fields,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      ...?fields,
    });
    return _dio.post(endpoint, data: formData);
  }
}

class ApiServiceException implements Exception {
  final String message;
  ApiServiceException(this.message);

  @override
  String toString() => message;
}
