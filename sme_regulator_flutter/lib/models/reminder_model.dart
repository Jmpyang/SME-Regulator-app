import 'package:json_annotation/json_annotation.dart';

part 'reminder_model.g.dart';

@JsonSerializable()
class ReminderModel {
  final String id;
  final String title;
  @JsonKey(name: 'expiry_date')
  final DateTime expiryDate;
  @JsonKey(name: 'days_remaining')
  final int daysRemaining;
  @JsonKey(name: 'document_type')
  final String documentType;

  ReminderModel({
    required this.id,
    required this.title,
    required this.expiryDate,
    required this.daysRemaining,
    required this.documentType,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      expiryDate: DateTime.tryParse((json['expiry_date'] as String?) ?? '') ?? DateTime.now(),
      daysRemaining: (json['days_remaining'] as num?)?.toInt() ?? 0,
      documentType: (json['document_type'] as String?) ?? '',
    );
  }
  Map<String, dynamic> toJson() => _$ReminderModelToJson(this);
}
