import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../models/document_model.dart';
import '../utils/api_parsers.dart';

class DocumentService {
  DocumentService(this._dio);

  final Dio _dio;

  Future<List<DocumentModel>> fetchDocuments() async {
    final response = await _dio.get('/api/documents/');
    final List<dynamic> data = decodeList(response.data);
    return data.map((json) => DocumentModel.fromJson(json)).toList();
  }

  Future<DocumentModel> uploadDocument(PlatformFile file, String title) async {
    MultipartFile fileBytes;
    
    if (file.bytes != null) {
      // Use bytes if available (web platform)
      fileBytes = MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
      );
    } else if (file.path != null) {
      // Read from file path if available (desktop/mobile platforms)
      fileBytes = await MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      );
    } else {
      throw Exception('No file data available for upload');
    }

    final formData = FormData.fromMap({
      'file': fileBytes,
      'title': title,
    });

    final response = await _dio.post('/api/documents/upload/', data: formData);
    return DocumentModel.fromJson(decodeMap(response.data));
  }

  Future<List<int>> downloadDocument(String id) async {
    final response = await _dio.get('/api/documents/$id/download/');
    return response.data is List<int> 
        ? response.data 
        : List<int>.from(response.data);
  }
}
