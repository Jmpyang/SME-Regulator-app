import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/document_model.dart';
import '../repositories/document_repository.dart';
import '../utils/error_handler.dart';

class DocumentProvider with ChangeNotifier {
  final DocumentRepository _repository;
  
  List<DocumentModel> _documents = [];
  bool _isLoading = false;
  String? _error;

  DocumentProvider(this._repository);

  List<DocumentModel> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loadDocuments() async {
    try {
      _setLoading(true);
      _documents = await _repository.getDocuments();
      _error = null;
    } catch (e) {
      _error = getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadDocument(PlatformFile file, String title) async {
    try {
      _setLoading(true);
      final doc = await _repository.uploadDocument(file, title);
      _documents.insert(0, doc);
      _error = null;
      return true;
    } catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
