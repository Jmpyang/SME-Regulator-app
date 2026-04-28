// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      businessName: json['business_name'] as String? ?? '',
      kraPin: json['kra_pin'] as String? ?? '',
      businessType: json['business_type'] as String? ?? '',
      county: json['county'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'job_title': instance.jobTitle,
      'business_name': instance.businessName,
      'kra_pin': instance.kraPin,
      'business_type': instance.businessType,
      'county': instance.county,
      'is_verified': instance.isVerified,
    };
