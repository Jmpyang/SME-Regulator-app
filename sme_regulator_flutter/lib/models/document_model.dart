import 'package:json_annotation/json_annotation.dart';

part 'document_model.g.dart';

@JsonSerializable()
class DocumentModel {
  final String id;
  final String title;
  @JsonKey(name: 'file_url')
  final String fileUrl;
  final String type;
  @JsonKey(name: 'uploaded_at')
  final DateTime uploadedAt;
  final String status;
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;
  @JsonKey(name: 'days_to_expiry')
  final int? daysToExpiry;

  DocumentModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.type,
    required this.uploadedAt,
    required this.status,
    this.expiryDate,
    this.daysToExpiry,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: (json['id']?.toString() ?? json['_id']?.toString() ?? json['document_id']?.toString()) ?? '',
      title: (json['title'] as String? ?? json['name'] as String? ?? json['document_name'] as String?)?.toString() ?? 'Unknown',
      fileUrl: (json['file_path'] as String? ?? json['file_url'] as String? ?? json['fileUrl'] as String? ?? json['url'] as String? ?? json['download_url'] as String?)?.toString() ?? '',
      type: (json['document_type'] as String? ?? json['type'] as String? ?? json['category'] as String?)?.toString() ?? 'Document',
      uploadedAt: DateTime.tryParse((json['uploaded_at'] as String? ?? json['createdAt'] as String? ?? json['created_at'] as String? ?? json['issue_date'] as String?) ?? '') ?? DateTime.now(),
      status: (json['document_type'] as String? ?? json['status'] as String? ?? json['state'] as String?)?.toString() ?? 'PROCESSING',
      expiryDate: json['expiry_date'] != null ? DateTime.tryParse(json['expiry_date'].toString()) : null,
      daysToExpiry: (json['days_to_expiry'] as num?)?.toInt(),
    );
  }
  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);
}
