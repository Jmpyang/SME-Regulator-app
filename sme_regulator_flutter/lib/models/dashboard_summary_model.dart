import 'package:json_annotation/json_annotation.dart';
import 'reminder_model.dart';

part 'dashboard_summary_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardSummaryModel {
  @JsonKey(name: 'compliance_score')
  final int complianceScore;
  
  @JsonKey(name: 'active_permits')
  final int activePermits;
  
  @JsonKey(name: 'missing_expired')
  final int missingExpired;
  
  @JsonKey(name: 'required_categories')
  final int requiredCategories;
  
  @JsonKey(name: 'upcoming_expiries', defaultValue: [])
  final List<ReminderModel> upcomingExpiries;

  DashboardSummaryModel({
    required this.complianceScore,
    required this.activePermits,
    required this.missingExpired,
    required this.requiredCategories,
    required this.upcomingExpiries,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) => _$DashboardSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);
}
