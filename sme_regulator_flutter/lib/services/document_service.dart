import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/document_model.dart';

class DocumentService {
  DocumentService(this._dio);

  final Dio _dio;

  Future<List<DocumentModel>> fetchDocuments() async {
    try {
      final response = await _dio.get('/api/vault/documents');
      
      // Handle different possible response structures
      List<dynamic> list;
      if (response.data is Map && response.data['documents'] != null) {
        list = response.data['documents'] as List;
      } else if (response.data is List) {
        list = response.data as List;
      } else if (response.data is Map && response.data['data'] != null) {
        list = response.data['data'] as List;
      } else {
        list = [];
      }
      
      return list.map((e) => DocumentModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Changed: Now accepts the file directly from the UI
  Future<bool> uploadDocument({
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

    final response = await _dio.post('/api/vault/documents', data: formData);
    
    // Trigger email notification after successful upload
    bool emailNotificationSent = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        await _dio.post('/api/notifications/send-email', data: {
          'document_id': response.data['id'] ?? response.data['_id'],
          'document_title': title,
          'document_type': documentType,
        });
        emailNotificationSent = true;
      } catch (e) {
        print('Email notification failed: $e');
      }
    }
    
    return emailNotificationSent;
  }

  Future<DocumentModel> getDocument(int id) async {
    final response = await _dio.get('/api/vault/documents/$id');
    return DocumentModel.fromJson(response.data as Map<String, dynamic>);
  }

  // Send document to AI processing endpoint for date extraction
  Future<void> processDocumentForAI(String documentId) async {
    try {
      await _dio.post('/api/ai/process-document', data: {
        'document_id': documentId,
      });
    } catch (e) {
      print('AI processing failed: $e');
      // Don't fail the operation if AI processing fails
      rethrow;
    }
  }

  Future<String> downloadDocument(String id, String fileName) async {
    final response = await _dio.get(
      '/api/documents/$id/download/',
      options: Options(responseType: ResponseType.bytes),
    );
    
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    
    // Write the bytes to the file
    await file.writeAsBytes(response.data);
    
    return file.path;
  }
}