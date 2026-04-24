import 'package:flutter/material.dart';
import '../models/dashboard_summary_model.dart';
import '../services/dashboard_service.dart';
import '../providers/loading_provider.dart';
import '../utils/error_handler.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _dashboardService;
  final LoadingProvider _loadingProvider;
  DashboardSummaryModel? _summary;
  String? _error;

  DashboardProvider(this._dashboardService, this._loadingProvider);

  DashboardSummaryModel? get summary => _summary;
  String? get error => _error;
  bool get isLoading => _loadingProvider.isLoading('dashboard');

  Future<void> fetchSummary() async {
    _error = null;
    _loadingProvider.setLoading('dashboard', true, message: 'Loading dashboard...');
    notifyListeners();

    try {
      _summary = await _dashboardService.fetchDashboardSummary();
    } catch (e) {
      _error = getErrorMessage(e);
    } finally {
      _loadingProvider.setLoading('dashboard', false);
      notifyListeners();
    }
  }
}
