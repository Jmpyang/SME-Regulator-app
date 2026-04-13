import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../utils/token_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const Duration _timeout = Duration(seconds: 10);
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<http.Response> get(String endpoint) async {
    await init();
    return _makeRequest('GET', endpoint);
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    await init();
    return _makeRequest('POST', endpoint, body: body);
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    await init();
    return _makeRequest('PUT', endpoint, body: body);
  }

  Future<http.Response> delete(String endpoint) async {
    await init();
    return _makeRequest('DELETE', endpoint);
  }

  Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final token = _prefs?.getString(TokenStorage.jwtKey);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    try {
      late http.Response response;
      
      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers).timeout(_timeout);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          ).timeout(_timeout);
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          ).timeout(_timeout);
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers).timeout(_timeout);
          break;
        default:
          throw UnsupportedError('HTTP method $method is not supported');
      }

      return _handleResponse(response);
    } on SocketException {
      throw ApiServiceException('Connection refused. Please check your internet connection.');
    } on HttpException {
      throw ApiServiceException('HTTP error occurred. Please try again.');
    } on FormatException {
      throw ApiServiceException('Invalid response format. Please try again.');
    } catch (e) {
      if (e is ApiServiceException) rethrow;
      throw ApiServiceException('Request timeout. Please check your connection and try again.');
    }
  }

  http.Response _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response;
      case 400:
        throw ApiServiceException('Bad request: ${response.body}');
      case 401:
        _prefs?.remove(TokenStorage.jwtKey);
        throw ApiServiceException('Unauthorized. Please login again.');
      case 403:
        throw ApiServiceException('Forbidden. You don\'t have permission to access this resource.');
      case 404:
        throw ApiServiceException('Resource not found. Please check your request.');
      case 500:
        throw ApiServiceException('Server error. Please try again later.');
      case 502:
      case 503:
      case 504:
        throw ApiServiceException('Service unavailable. Please try again later.');
      default:
        throw ApiServiceException('Request failed with status ${response.statusCode}: ${response.body}');
    }
  }

  Future<http.StreamedResponse> uploadFile(
    String endpoint,
    String filePath,
    String fileName,
  ) async {
    await init();
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final token = _prefs?.getString(TokenStorage.jwtKey);

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    });

    final file = await http.MultipartFile.fromPath('file', filePath, filename: fileName);
    request.files.add(file);

    try {
      final response = await request.send().timeout(_timeout);
      return _handleStreamedResponse(response);
    } on SocketException {
      throw ApiServiceException('Connection refused. Please check your internet connection.');
    } catch (e) {
      if (e is ApiServiceException) rethrow;
      throw ApiServiceException('Upload timeout. Please check your connection and try again.');
    }
  }

  http.StreamedResponse _handleStreamedResponse(http.StreamedResponse response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw ApiServiceException('Bad request during upload');
      case 401:
        _prefs?.remove(TokenStorage.jwtKey);
        throw ApiServiceException('Unauthorized. Please login again.');
      case 403:
        throw ApiServiceException('Forbidden. You don\'t have permission to upload this file.');
      case 404:
        throw ApiServiceException('Upload endpoint not found.');
      case 500:
        throw ApiServiceException('Server error during upload. Please try again later.');
      default:
        throw ApiServiceException('Upload failed with status ${response.statusCode}');
    }
  }
}

class ApiServiceException implements Exception {
  final String message;
  ApiServiceException(this.message);

  @override
  String toString() => message;
}
