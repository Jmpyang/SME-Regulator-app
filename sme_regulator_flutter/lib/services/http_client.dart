import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../utils/secure_storage_helper.dart';

class AppHttpClient {
  late final Dio dio;

  AppHttpClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Inject token if available
          final token = await SecureStorageHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Handle token expiration/unauthorized appropriately
            await SecureStorageHelper.deleteToken();
            // In a real app we might use a global navigator key to route to login here
          }
          return handler.next(e);
        },
      ),
    );
  }
}
