import 'package:dio/dio.dart';

/// Human-readable message from [DioException] (FastAPI often returns `detail`).
String dioErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
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
    }
    if (data is String && data.isNotEmpty) return data;
    return error.message ?? 'Request failed';
  }
  return error.toString();
}
