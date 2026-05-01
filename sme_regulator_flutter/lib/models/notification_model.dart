class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // 'success', 'action_required', 'expiry_alert', 'info'
  final DateTime createdAt;
  final bool isRead;
  final String? documentId;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.documentId,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? 'info',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      isRead: json['is_read'] as bool? ?? false,
      documentId: json['document_id'] as String?,
    );
  }
}
