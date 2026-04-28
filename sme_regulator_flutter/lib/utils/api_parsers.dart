import '../models/document_model.dart';
import '../models/reminder_model.dart';

/// Normalizes list responses whether the API returns a raw list or `{ data: [...] }`.
List<dynamic> decodeList(dynamic responseData) {
  if (responseData is List) return responseData;
  if (responseData is Map) {
    for (final key in ['data', 'items', 'results', 'documents', 'permits', 'reminders']) {
      final v = responseData[key];
      if (v is List) return v;
    }
  }
  return [];
}

Map<String, dynamic> decodeMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return {};
}

DocumentModel parseDocument(dynamic raw) {
  final json = decodeMap(raw);
  final uploaded = json['uploaded_at'] ?? json['created_at'];
  return DocumentModel(
    id: json['id']?.toString() ?? '',
    title: json['title'] as String? ?? 'Untitled',
    fileUrl: json['file_url'] as String? ?? json['url'] as String? ?? '',
    type: json['document_type'] as String? ?? json['type'] as String? ?? '',
    uploadedAt: uploaded != null
        ? DateTime.tryParse(uploaded.toString()) ?? DateTime.now()
        : DateTime.now(),
    status: json['status']?.toString() ?? 'PROCESSING',
  );
}

ReminderModel parseReminder(dynamic raw) {
  final json = decodeMap(raw);
  final expiry = json['expiry_date'];
  final expiryDate = expiry != null
      ? DateTime.tryParse(expiry.toString()) ?? DateTime.now()
      : DateTime.now();
  final days = json['days_remaining'];
  return ReminderModel(
    id: json['id']?.toString() ?? '',
    title: json['title'] as String? ?? '',
    expiryDate: expiryDate,
    daysRemaining: days is int ? days : int.tryParse(days?.toString() ?? '') ?? 0,
    documentType: json['document_type'] as String? ?? json['type'] as String? ?? '',
  );
}
