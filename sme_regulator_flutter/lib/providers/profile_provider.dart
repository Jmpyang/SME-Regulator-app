import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import '../providers/auth_provider.dart';
import '../utils/error_handler.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _service;
  final AuthProvider _authProvider;
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  ProfileProvider(this._service, this._authProvider);

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _service.getProfile();
    } catch (e) {
      // Use a robust error handler consistent with your Dio setup
      _error = e is DioException ? friendlyError(e) : e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _service.updateProfile(data);
      
      // Update only the user name in AuthProvider instead of refreshing entire session
      if (_authProvider.user != null && data.containsKey('first_name') || data.containsKey('last_name')) {
        _authProvider.updateUserName(
          firstName: data['first_name'] ?? _profile?.firstName ?? '',
          lastName: data['last_name'] ?? _profile?.lastName ?? '',
        );
      }
      
      return true;
    } catch (e) {
      _error = e is DioException ? friendlyError(e) : e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}