import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../models/document_model.dart';
import '../utils/api_parsers.dart';

class DocumentService {
  DocumentService(this._dio);

  final Dio _dio;

  static const String _vaultBase = '/api/vault/documents';

  Future<List<DocumentModel>> fetchDocuments() async {
    final response = await _dio.get(_vaultBase);
    return decodeList(response.data).map((e) => parseDocument(e)).toList();
  }

  Future<DocumentModel> uploadDocument(PlatformFile file, String title) async {
    final MultipartFile mf;
    if (file.bytes != null) {
      mf = MultipartFile.fromBytes(file.bytes!, filename: file.name);
    } else if (file.path != null) {
      mf = await MultipartFile.fromFile(file.path!, filename: file.name);
    } else {
      throw StateError('No file bytes or path available for upload');
    }

    final formData = FormData.fromMap({
      'file': mf,
      if (title.isNotEmpty) 'title': title,
    });

    final response = await _dio.post<dynamic>(
      _vaultBase,
      data: formData,
    );
    return parseDocument(decodeMap(response.data));
  }

  /// Single document metadata (JSON).
  Future<DocumentModel> fetchDocument(String documentId) async {
    final response = await _dio.get('$_vaultBase/$documentId');
    return parseDocument(decodeMap(response.data));
  }

  /// Raw file bytes for download/preview (if the same URL serves the file).
  Future<List<int>> downloadDocument(String documentId) async {
    final response = await _dio.get<dynamic>(
      '$_vaultBase/$documentId',
      options: Options(responseType: ResponseType.bytes),
    );
    final data = response.data;
    if (data is List<int>) return data;
    if (data is Uint8List) return data.toList();
    return [];
  }
}
