import 'package:file_picker/file_picker.dart';
import '../models/document_model.dart';
import '../services/document_service.dart';

class DocumentRepository {
  final DocumentService _documentService;

  DocumentRepository(this._documentService);

  Future<List<DocumentModel>> getDocuments() async {
    return await _documentService.fetchDocuments();
  }

  Future<DocumentModel> uploadDocument(PlatformFile file, String title) async {
    return await _documentService.uploadDocument(file, title);
  }

  Future<List<int>> downloadDocument(String id) async {
    return await _documentService.downloadDocument(id);
  }
}
