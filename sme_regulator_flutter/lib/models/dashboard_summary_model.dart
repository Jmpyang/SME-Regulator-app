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

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    // Apply null-safe pattern as specified in windsurf_flutter_v2.md
    return DashboardSummaryModel(
      complianceScore: (json['compliance_score'] as num?)?.toInt() ?? 0,
      activePermits: (json['active_permits'] as num?)?.toInt() ?? 0,
      missingExpired: (json['missing_expired'] as num?)?.toInt() ?? 0,
      requiredCategories: (json['required_categories'] as num?)?.toInt() ?? 0,
      upcomingExpiries: (json['upcoming_expiries'] as List?)?.map((e) => ReminderModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }
  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);
}
