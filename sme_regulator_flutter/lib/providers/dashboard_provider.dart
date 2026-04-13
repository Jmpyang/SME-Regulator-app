import 'package:flutter/material.dart';
import '../models/dashboard_summary_model.dart';
import '../services/dashboard_service.dart';
import '../utils/dio_errors.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _service;
  DashboardSummaryModel? _summary;
  bool _isLoading = false;
  String? _error;

  DashboardProvider(this._service);

  DashboardSummaryModel? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSummary() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _summary = await _service.fetchDashboardSummary();
    } catch (e) {
      _error = dioErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
