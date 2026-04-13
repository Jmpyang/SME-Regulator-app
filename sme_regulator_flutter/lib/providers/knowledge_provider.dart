import 'package:flutter/material.dart';
import '../services/knowledge_service.dart';

class KnowledgeProvider with ChangeNotifier {
  final KnowledgeService _service;
  
  List<String> _industries = [];
  List<String> _counties = [];
  List<Map<String, dynamic>> _complianceItems = [];
  bool _isLoading = false;
  String? _error;

  KnowledgeProvider(this._service);

  List<String> get industries => _industries;
  List<String> get counties => _counties;
  List<Map<String, dynamic>> get complianceItems => _complianceItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFormData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final futures = await Future.wait([
        _service.getIndustries(),
        _service.getCounties(),
      ]);
      _industries = futures[0];
      _counties = futures[1];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _complianceItems = await _service.searchItems(query);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
