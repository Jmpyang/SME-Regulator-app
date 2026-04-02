import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../utils/secure_storage_helper.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    
    // Assuming backend returns { "token": "...", "user": { ... } }
    final token = response.data['token'] as String?;
    if (token != null) {
      await SecureStorageHelper.saveToken(token);
    }
    return UserModel.fromJson(response.data['user']);
  }

  Future<void> register(Map<String, dynamic> data) async {
    await _dio.post('/auth/register', data: data);
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await _dio.post('/auth/verify', data: {
      'email': email,
      'otp': otp,
    });
    final token = response.data['token'] as String?;
    if (token != null) {
      await SecureStorageHelper.saveToken(token);
    }
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post('/auth/forgot-password', data: {'email': email});
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    await _dio.post('/auth/reset-password', data: {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
    });
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get('/auth/me');
    return UserModel.fromJson(response.data);
  }
}
