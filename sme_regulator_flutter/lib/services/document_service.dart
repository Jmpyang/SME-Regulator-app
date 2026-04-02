import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/document_model.dart';

class DocumentService {
  final Dio _dio;

  DocumentService(this._dio);

  Future<List<DocumentModel>> fetchDocuments() async {
    final response = await _dio.get('/documents');
    final data = response.data as List;
    return data.map((e) => DocumentModel.fromJson(e)).toList();
  }

  Future<DocumentModel> uploadDocument(PlatformFile file, String title) async {
    final formData = FormData.fromMap({
      'title': title,
      'file': await MultipartFile.fromFile(file.path!, filename: file.name),
    });
    
    final response = await _dio.post('/documents/upload', data: formData);
    return DocumentModel.fromJson(response.data);
  }

  // Assuming downloading returns raw bytes or a URL
  Future<List<int>> downloadDocument(String id) async {
    final response = await _dio.get(
      '/documents/$id/download',
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }
}
