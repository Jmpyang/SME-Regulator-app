import 'package:flutter/material.dart';
import '../models/dashboard_summary_model.dart';
import '../models/compliance_model.dart';
import '../services/dashboard_service.dart';
import '../providers/loading_provider.dart';
import '../providers/document_provider.dart';
import '../providers/profile_provider.dart';
import '../utils/error_handler.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _dashboardService;
  final LoadingProvider _loadingProvider;
  final DocumentProvider _documentProvider;
  final ProfileProvider _profileProvider;
  
  DashboardSummaryModel? _summary;
  ComplianceModel? _compliance;
  String? _error;
  bool _isComplianceCalculated = false;

  DashboardProvider(this._dashboardService, this._loadingProvider, this._documentProvider, this._profileProvider) {
    _documentProvider.addListener(_onDocumentsChanged);
    _profileProvider.addListener(_onProfileChanged);
  }

  DashboardSummaryModel? get summary => _summary;
  ComplianceModel? get compliance => _compliance;
  String? get error => _error;
  bool get isLoading => _loadingProvider.isLoading('dashboard');
  bool get isComplianceCalculated => _isComplianceCalculated;

  void _onDocumentsChanged() {
    // Recalculate compliance when documents change
    _calculateCompliance();
  }

  void _onProfileChanged() {
    // Recalculate compliance when profile changes (business_type may have changed)
    _calculateCompliance();
  }

  void _calculateCompliance() {
    final documents = _documentProvider.documents;
    final profile = _profileProvider.profile;
    final businessType = profile?.businessType;
    
    final documentData = documents.map((doc) => DocumentData(
      id: doc.id,
      title: doc.title,
      type: doc.type,
      status: doc.status,
      uploadedAt: doc.uploadedAt,
      expiryDate: doc.expiryDate,
      daysToExpiry: doc.daysToExpiry,
    )).toList();

    _compliance = ComplianceModel.calculate(documentData, businessType: businessType);
    _isComplianceCalculated = true;
    notifyListeners();
  }

  Future<void> fetchSummary() async {
    _error = null;
    _loadingProvider.setLoading('dashboard', true, message: 'Loading dashboard...');
    notifyListeners();

    try {
      _summary = await _dashboardService.fetchDashboardSummary();
      // Calculate compliance after fetching summary
      _calculateCompliance();
    } catch (e) {
      _error = getErrorMessage(e);
      // Still calculate compliance even if API fails
      _calculateCompliance();
    } finally {
      _loadingProvider.setLoading('dashboard', false);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _documentProvider.removeListener(_onDocumentsChanged);
    _profileProvider.removeListener(_onProfileChanged);
    super.dispose();
  }
}
