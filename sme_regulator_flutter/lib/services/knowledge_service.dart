import 'package:dio/dio.dart';

import '../utils/api_parsers.dart';

class KnowledgeService {
  KnowledgeService(this._dio);

  final Dio _dio;

  Future<List<String>> getIndustries() async {
    final response = await _dio.get('/api/knowledge/industries');
    return decodeList(response.data).map((e) => e.toString()).toList();
  }

  Future<List<String>> getCounties() async {
    final response = await _dio.get('/api/knowledge/counties');
    return decodeList(response.data).map((e) => e.toString()).toList();
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final response = await _dio.get('/api/knowledge/items');
    return decodeList(response.data).map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>> getItem(String itemId) async {
    final response = await _dio.get('/api/knowledge/item/$itemId');
    return decodeMap(response.data);
  }

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    final response = await _dio.get(
      '/api/knowledge/search',
      queryParameters: {'q': query},
    );
    return decodeList(response.data).map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>> checkComplianceRequirements(Map<String, dynamic> businessData) async {
    final response = await _dio.post('/api/knowledge/compliance/check', data: businessData);
    return decodeMap(response.data);
  }
}
