import 'dart:async';
import 'package:flutter/material.dart';
import '../models/document_model.dart';
import '../repositories/document_repository.dart';
import '../utils/error_handler.dart';
import 'package:file_picker/file_picker.dart';

class DocumentProvider with ChangeNotifier {
  final DocumentRepository _repository;
  
  List<DocumentModel> _documents = [];
  bool _isLoading = false;
  String? _error;
  Timer? _syncTimer;
  String? _emailNotificationStatus;

  DocumentProvider(this._repository);

  List<DocumentModel> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get emailNotificationStatus => _emailNotificationStatus;

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
    required PlatformFile pickedFile,
  }) async {
    try {
      _setLoading(true);
      _emailNotificationStatus = null;
      
      final emailNotificationSent = await _repository.uploadDocument(
        title: title,
        documentType: documentType,
        pickedFile: pickedFile,
      );
      
      // Set email notification status for UI feedback
      _emailNotificationStatus = emailNotificationSent ? 'sent' : 'failed';
      
      await loadDocuments(); // Refresh the list
      _error = null;
      
      // Call AI processing for date extraction after successful upload
      if (_documents.isNotEmpty) {
        final uploadedDoc = _documents.firstWhere(
          (doc) => doc.title == title,
          orElse: () => _documents.last,
        );
        try {
          await _repository.processDocumentForAI(uploadedDoc.id);
        } catch (e) {
          print('AI processing failed: $e');
          // Don't fail the upload if AI processing fails
        }
      }
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

  Future<String> downloadDocument(String id, String fileName) async {
    try {
      final filePath = await _repository.downloadDocument(id, fileName);
      return filePath;
    } catch (e) {
      _error = getErrorMessage(e);
      rethrow;
    }
  }

  @override
  void dispose() {
    stopSync();
    super.dispose();
  }
}
