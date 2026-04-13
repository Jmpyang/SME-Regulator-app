import 'package:dio/dio.dart';

import '../models/user_model.dart';
import '../utils/api_parsers.dart';
import '../utils/token_storage.dart';

class AuthService {
  AuthService(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  bool get hasToken => (_tokenStorage.accessToken ?? '').isNotEmpty;

  String? _extractAccessToken(Map<String, dynamic> data) {
    final t = data['access_token'] ?? data['token'] ?? data['accessToken'];
    return t?.toString();
  }

  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );

    final data = response.data ?? {};
    final token = _extractAccessToken(data);
    if (token != null && token.isNotEmpty) {
      await _tokenStorage.setAccessToken(token);
    }

    if (data['user'] is Map<String, dynamic>) {
      return UserModel.fromProfileMap(Map<String, dynamic>.from(data['user'] as Map));
    }

    return getCurrentUser();
  }

  Future<void> register(Map<String, dynamic> data) async {
    await _dio.post('/api/auth/register', data: data);
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/verify-otp',
      data: {'email': email, 'otp': otp},
    );
    final data = response.data ?? {};
    final token = _extractAccessToken(data);
    if (token != null && token.isNotEmpty) {
      await _tokenStorage.setAccessToken(token);
    }
  }

  Future<void> requestOtp(String email, String phone) async {
    await _dio.post('/api/auth/request-otp', data: {'email': email, 'phone': phone});
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post('/api/auth/forgot-password', data: {'email': email});
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    await _dio.post('/api/auth/reset-password', data: {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    });
  }

  Future<UserModel> googleLogin(String idToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/auth/google',
      data: {'idToken': idToken},
    );
    final data = response.data ?? {};
    final token = _extractAccessToken(data);
    if (token != null && token.isNotEmpty) {
      await _tokenStorage.setAccessToken(token);
    }
    if (data['user'] is Map<String, dynamic>) {
      return UserModel.fromProfileMap(Map<String, dynamic>.from(data['user'] as Map));
    }
    return getCurrentUser();
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get('/api/profile/');
    return UserModel.fromProfileMap(decodeMap(response.data));
  }

  Future<void> logout() => _tokenStorage.setAccessToken(null);
}
