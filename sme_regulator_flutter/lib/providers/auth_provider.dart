import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../utils/error_handler.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

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
    if (!await _repository.hasSavedToken) return false;

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
    try {
      _setLoading(true);
      _user = await _repository.login(email, password);
      _setError(null);
      return true;
    } on DioException catch (e) {
      _error = getErrorMessage(e);
      return false;
    } catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithGoogle(String idToken) async {
    try {
      _setLoading(true);
      await _repository.loginWithGoogle(idToken);
      _user = await _repository.getCurrentUser();
      _setError(null);
      return true;
    } catch (e) {
      await logout();
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      _setLoading(true);
      await _repository.changePassword(currentPassword, newPassword);
      _setError(null);
      return true;
    } on DioException catch (e) {
      _error = getErrorMessage(e);
      return false;
    } catch (e) {
      _error = getErrorMessage(e);
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
      _error = getErrorMessage(e);
      return false;
    } catch (e) {
      _error = getErrorMessage(e);
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
      _error = getErrorMessage(e);
      return false;
    } catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    notifyListeners();
  }
}
