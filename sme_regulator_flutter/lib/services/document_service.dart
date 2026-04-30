import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/document_model.dart';

class DocumentService {
  DocumentService(this._dio);

  final Dio _dio;

  Future<List<DocumentModel>> fetchDocuments() async {
    try {
      final response = await _dio.get('/api/vault/documents');
      // Ensure we are accessing the correct key based on your FastAPI response
      final list = (response.data['documents'] as List?) ?? [];
      return list.map((e) => DocumentModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  // Changed: Now accepts the file directly from the UI
  Future<void> uploadDocument({
    required String title,
    required String documentType,
    required PlatformFile pickedFile,
  }) async {
    if (pickedFile.path == null) throw Exception("File path is missing");

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        pickedFile.path!,
        filename: pickedFile.name,
      ),
      'title': title,
      'document_type': documentType,
    });

    await _dio.post('/api/vault/documents', data: formData);
  }

  Future<DocumentModel> getDocument(int id) async {
    final response = await _dio.get('/api/vault/documents/$id');
    return DocumentModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<int>> downloadDocument(String id) async {
    final response = await _dio.get(
      '/api/documents/$id/download/',
      options: Options(responseType: ResponseType.bytes), // Crucial for downloads
    );
    return List<int>.from(response.data);
  }
}