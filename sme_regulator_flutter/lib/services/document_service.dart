import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/document_model.dart';

class DocumentService {
  DocumentService(this._dio);

  final Dio _dio;

  Future<List<DocumentModel>> fetchDocuments() async {
    try {
      final response = await _dio.get('/api/vault/documents');
      final list = (response.data['documents'] as List?) ?? [];
      return list.map((e) => DocumentModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      // 404 just means empty — not a real error
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  Future<void> uploadDocument({
    required String title,
    required String documentType,
  }) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result == null) return; // user cancelled

    final file = result.files.single;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      ),
      'title': title,
      'document_type': documentType,
    });

    await _dio.post('/api/vault/documents', data: formData);
  }

  Future<DocumentModel> getDocument(int id) async {
    try {
      final response = await _dio.get('/api/vault/documents/$id');
      return DocumentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) rethrow;
      rethrow;
    }
  }

  Future<List<int>> downloadDocument(String id) async {
    final response = await _dio.get('/api/documents/$id/download/');
    return response.data is List<int> 
        ? response.data 
        : List<int>.from(response.data);
  }
}
