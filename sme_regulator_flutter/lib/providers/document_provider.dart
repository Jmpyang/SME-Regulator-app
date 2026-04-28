import 'dart:async';
import 'package:flutter/material.dart';
import '../models/document_model.dart';
import '../repositories/document_repository.dart';
import '../utils/error_handler.dart';

class DocumentProvider with ChangeNotifier {
  final DocumentRepository _repository;
  
  List<DocumentModel> _documents = [];
  bool _isLoading = false;
  String? _error;
  Timer? _syncTimer;

  DocumentProvider(this._repository);

  List<DocumentModel> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loadDocuments() async {
    _isLoading = true;
    notifyListeners(); // show existing data + loading indicator
    try {
      _documents = await _repository.getDocuments();
      _error = null;
    } catch (e) {
      // keep showing old data, show snackbar error
      _error = getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadDocument({
    required String title,
    required String documentType,
  }) async {
    try {
      _setLoading(true);
      await _repository.uploadDocument(title: title, documentType: documentType);
      await loadDocuments(); // Refresh the list
      _error = null;
    } catch (e) {
      _error = getErrorMessage(e);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void startSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await fetchDocuments(); // silent refresh, no loading indicator
    });
  }

  void stopSync() => _syncTimer?.cancel();

  Future<void> fetchDocuments() async {
    try {
      _documents = await _repository.getDocuments();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = getErrorMessage(e);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopSync();
    super.dispose();
  }
}
