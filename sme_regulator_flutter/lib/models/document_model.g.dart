// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      fileUrl: json['file_url'] as String,
      type: json['type'] as String,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'file_url': instance.fileUrl,
      'type': instance.type,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
      'status': instance.status,
    };
