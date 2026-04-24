import 'package:dio/dio.dart';
import 'app_exceptions.dart';

/// Converts various error types to well-defined AppException instances
AppException handleError(dynamic error) {
  if (error is AppException) {
    return error;
  }
  
  if (error is DioException) {
    return _handleDioException(error);
  }
  
  // Handle other common error types
  if (error is FormatException) {
    return const ValidationException('Invalid data format received from server');
  }
  
  if (error is TypeError) {
    return const ValidationException('Data type mismatch occurred');
  }
  
  return UnknownException(
    error.toString(),
    originalError: error,
  );
}

AppException _handleDioException(DioException dioError) {
  final statusCode = dioError.response?.statusCode;
  final data = dioError.response?.data;
  
  // Extract error message from response data
  String? extractMessage() {
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String) return detail;
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first['msg'] != null) {
          return first['msg'].toString();
        }
        return detail.first.toString();
      }
      if (data['message'] != null) return data['message'].toString();
      if (data['error'] != null) return data['error'].toString();
    }
    if (data is String && data.isNotEmpty) return data;
    return dioError.message;
  }
  
  final message = extractMessage() ?? 'Request failed';
  
  switch (dioError.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return NetworkException('Connection timeout. Please check your internet connection.');
      
    case DioExceptionType.connectionError:
      return NetworkException('No internet connection. Please check your network settings.');
      
    case DioExceptionType.badResponse:
      switch (statusCode) {
        case 400:
          return ValidationException(message);
        case 401:
          return AuthException('Authentication required. Please log in again.');
        case 403:
          return AuthException('Access denied. You don\'t have permission to perform this action.');
        case 404:
          return ServerException('The requested resource was not found.');
        case 422:
          return ValidationException('Invalid data provided: $message');
        case 429:
          return ServerException('Too many requests. Please try again later.');
        case 500:
        case 502:
        case 503:
        case 504:
          return ServerException('Server error. Please try again later.');
        default:
          return ServerException('Server error ($statusCode): $message');
      }
      
    case DioExceptionType.cancel:
      return const NetworkException('Request was cancelled');
      
    case DioExceptionType.unknown:
      return NetworkException('Network error: ${dioError.message ?? "Unknown error occurred"}');
      
    default:
      return UnknownException('Unexpected error: $message');
  }
}

/// Gets a user-friendly error message from any error
String getErrorMessage(dynamic error) {
  final appException = handleError(error);
  return appException.message;
}
