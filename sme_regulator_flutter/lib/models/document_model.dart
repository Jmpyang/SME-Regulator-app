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

  DocumentModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.type,
    required this.uploadedAt,
    required this.status,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      fileUrl: (json['file_url'] as String?) ?? '',
      type: (json['type'] as String?) ?? '',
      uploadedAt: DateTime.tryParse((json['uploaded_at'] as String?) ?? '') ?? DateTime.now(),
      status: (json['status'] as String?) ?? 'PROCESSING',
    );
  }
  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);
}
