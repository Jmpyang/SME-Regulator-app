import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import '../utils/error_handler.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _service;
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  ProfileProvider(this._service);

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