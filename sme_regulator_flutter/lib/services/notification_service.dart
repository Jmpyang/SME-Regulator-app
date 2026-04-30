import 'package:dio/dio.dart';
import '../models/notification_model.dart'; // Import the model instead of redefining it

class NotificationService {
  final Dio _dio;
  NotificationService(this._dio);

  Future<List<AppNotification>> getNotifications() async {
    try {
      // Ensure the trailing slash matches your FastAPI router configuration
      final response = await _dio.get('/api/notifications/'); 
      final list = (response.data as List?) ?? [];
      return list.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  Future<void> markAsRead(String id) async {
    // Changed id to String to match your AppNotification model definition
    await _dio.put('/api/notifications/$id/read');
  }
}