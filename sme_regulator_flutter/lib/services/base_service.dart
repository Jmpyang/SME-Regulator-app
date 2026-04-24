import 'package:dio/dio.dart';
import '../utils/api_parsers.dart';

/// Base service class that provides common functionality for all API services
abstract class BaseService {
  final Dio _dio;
  
  BaseService(this._dio);
  
  /// Get the Dio instance for making HTTP requests
  Dio get dio => _dio;
  
  /// Make a GET request and parse the response as a list
  Future<List<T>> getList<T>(
    String endpoint, 
    T Function(dynamic) parser,
  ) async {
    final response = await _dio.get(endpoint);
    return decodeList(response.data).map(parser).toList();
  }
  
  /// Make a GET request and parse the response as a single object
  Future<T> get<T>(
    String endpoint, 
    T Function(dynamic) parser,
  ) async {
    final response = await _dio.get(endpoint);
    return parser(decodeMap(response.data));
  }
  
  /// Make a POST request and parse the response
  Future<T> post<T>(
    String endpoint, 
    dynamic data, 
    T Function(dynamic) parser,
  ) async {
    final response = await _dio.post(endpoint, data: data);
    return parser(decodeMap(response.data));
  }
  
  /// Make a PUT request and parse the response
  Future<T> put<T>(
    String endpoint, 
    dynamic data, 
    T Function(dynamic) parser,
  ) async {
    final response = await _dio.put(endpoint, data: data);
    return parser(decodeMap(response.data));
  }
  
  /// Make a DELETE request
  Future<void> delete(String endpoint) async {
    await _dio.delete(endpoint);
  }
  
  /// Make a GET request with query parameters and parse as list
  Future<List<T>> getListWithQuery<T>(
    String endpoint,
    Map<String, dynamic> queryParameters,
    T Function(dynamic) parser,
  ) async {
    final response = await _dio.get(
      endpoint,
      queryParameters: queryParameters,
    );
    return decodeList(response.data).map(parser).toList();
  }
}
