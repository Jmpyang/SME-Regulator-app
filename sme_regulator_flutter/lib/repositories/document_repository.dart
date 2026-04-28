import '../models/document_model.dart';
import '../services/document_service.dart';

class DocumentRepository {
  final DocumentService _documentService;

  DocumentRepository(this._documentService);

  Future<List<DocumentModel>> getDocuments() async {
    return await _documentService.fetchDocuments();
  }

  Future<void> uploadDocument({
    required String title,
    required String documentType,
  }) async {
    await _documentService.uploadDocument(title: title, documentType: documentType);
  }

  Future<List<int>> downloadDocument(String id) async {
    return await _documentService.downloadDocument(id);
  }
}
