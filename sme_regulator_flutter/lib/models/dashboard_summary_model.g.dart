// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummaryModel _$DashboardSummaryModelFromJson(
        Map<String, dynamic> json) =>
    DashboardSummaryModel(
      complianceScore: (json['compliance_score'] as num?)?.toInt() ?? 0,
      activePermits: (json['active_permits'] as num?)?.toInt() ?? 0,
      missingExpired: (json['missing_expired'] as num?)?.toInt() ?? 0,
      requiredCategories: (json['required_categories'] as num?)?.toInt() ?? 0,
      upcomingExpiries: (json['upcoming_expiries'] as List<dynamic>?)
              ?.map((e) => ReminderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DashboardSummaryModelToJson(
        DashboardSummaryModel instance) =>
    <String, dynamic>{
      'compliance_score': instance.complianceScore,
      'active_permits': instance.activePermits,
      'missing_expired': instance.missingExpired,
      'required_categories': instance.requiredCategories,
      'upcoming_expiries':
          instance.upcomingExpiries.map((e) => e.toJson()).toList(),
    };
