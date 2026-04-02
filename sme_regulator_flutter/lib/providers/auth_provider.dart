import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../utils/secure_storage_helper.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository;
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._repository);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? err) {
    _error = err;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    final token = await SecureStorageHelper.getToken();
    if (token == null || token.isEmpty) return false;
    
    // DEVELOPMENT MOCK (bypassing backend for dev)
    if (token == 'mock_development_token') {
      _user = UserModel(id: 'mock_id', email: 'admin@test.com', name: 'Mock Admin', phone: '0700000000', role: 'admin');
      _setError(null);
      return true;
    }

    try {
      _setLoading(true);
      _user = await _repository.getCurrentUser();
      _setError(null);
      return true;
    } catch (e) {
      await logout();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    // DEVELOPMENT MOCK (bypassing backend for dev)
    if (email == 'admin@test.com' && password == 'password') {
      _setLoading(true);
      await Future.delayed(const Duration(seconds: 1)); // Simulate network request
      _user = UserModel(id: 'mock_id', email: email, name: 'Mock Admin', phone: '0700000000', role: 'admin');
      _setError(null);
      await SecureStorageHelper.saveToken('mock_development_token');
      _setLoading(false);
      return true;
    }

    try {
      _setLoading(true);
      _user = await _repository.login(email, password);
      _setError(null);
      return true;
    } on DioException catch (e) {
      _setError(e.response?.data['message'] ?? 'Login failed');
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      await _repository.register(data);
      _setError(null);
      return true;
    } on DioException catch (e) {
      _setError(e.response?.data['message'] ?? 'Registration failed');
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      _setLoading(true);
      await _repository.verifyOtp(email, otp);
      _user = await _repository.getCurrentUser();
      _setError(null);
      return true;
    } on DioException catch (e) {
      _setError(e.response?.data['message'] ?? 'OTP verification failed');
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await SecureStorageHelper.deleteToken();
    _user = null;
    notifyListeners();
  }
}
