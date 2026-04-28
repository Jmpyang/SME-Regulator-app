import 'package:dio/dio.dart';

class NotificationService {
  NotificationService(this._dio);

  final Dio _dio;

  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await _dio.get('/api/notifications/');
      final list = (response.data as List?) ?? [];
      return list.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      rethrow;
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dio.put('/api/notifications/$id/read');
    } on DioException catch (e) {
      rethrow;
    }
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      isRead: json['is_read'] as bool? ?? false,
    );
  }
}
