// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderModel _$ReminderModelFromJson(Map<String, dynamic> json) =>
    ReminderModel(
      id: json['id'] as String,
      title: json['title'] as String,
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      daysRemaining: json['days_remaining'] as int? ?? 0,
      documentType: json['document_type'] as String? ?? 'Permit',
    );

Map<String, dynamic> _$ReminderModelToJson(ReminderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'expiry_date': instance.expiryDate.toIso8601String(),
      'days_remaining': instance.daysRemaining,
      'document_type': instance.documentType,
    };
