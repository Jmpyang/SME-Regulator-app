import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/dashboard_summary_model.dart';
import '../services/api_service.dart';
import '../providers/loading_provider.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService;
  final LoadingProvider _loadingProvider;
  DashboardSummaryModel? _summary;
  String? _error;

  DashboardProvider(this._apiService, this._loadingProvider);

  DashboardSummaryModel? get summary => _summary;
  String? get error => _error;
  bool get isLoading => _loadingProvider.isLoading('dashboard');

  Future<void> fetchSummary() async {
    _error = null;
    _loadingProvider.setLoading('dashboard', true, message: 'Loading dashboard...');
    notifyListeners();

    try {
      final response = await _apiService.get('/dashboard/summary');
      final responseData = json.decode(response.body);
      _summary = DashboardSummaryModel.fromJson(responseData);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loadingProvider.setLoading('dashboard', false);
      notifyListeners();
    }
  }
}
