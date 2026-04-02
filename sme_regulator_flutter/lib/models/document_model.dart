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

  DocumentModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.type,
    required this.uploadedAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => _$DocumentModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);
}
