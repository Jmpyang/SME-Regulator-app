import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../utils/token_storage.dart';

/// Shared [Dio] instance with JWT [Authorization] header from [SharedPreferences].
class ApiClient {
  ApiClient(SharedPreferences prefs) : _prefs = prefs {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConfig.connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _prefs.getString(TokenStorage.jwtKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await _prefs.remove(TokenStorage.jwtKey);
          }
          return handler.next(e);
        },
      ),
    );
  }

  final SharedPreferences _prefs;
  late final Dio dio;
}
