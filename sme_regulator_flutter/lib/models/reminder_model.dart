import 'package:json_annotation/json_annotation.dart';

part 'reminder_model.g.dart';

@JsonSerializable()
class ReminderModel {
  final String id;
  final String title;
  final String description;
  @JsonKey(name: 'due_date')
  final DateTime dueDate;
  final bool completed;

  ReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completed,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => _$ReminderModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderModelToJson(this);
}
