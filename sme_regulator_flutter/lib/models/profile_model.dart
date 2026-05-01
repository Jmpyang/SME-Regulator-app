import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String id;
  final String email;
  @JsonKey(name: 'first_name', defaultValue: '')
  final String firstName;
  @JsonKey(name: 'last_name', defaultValue: '')
  final String lastName;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(name: 'job_title', defaultValue: '')
  final String jobTitle;
  @JsonKey(name: 'business_name', defaultValue: '')
  final String businessName;
  @JsonKey(name: 'kra_pin', defaultValue: '')
  final String kraPin;
  @JsonKey(name: 'business_type', defaultValue: '')
  final String businessType;
  @JsonKey(defaultValue: '')
  final String county;
  @JsonKey(name: 'is_verified', defaultValue: false)
  final bool isVerified;

  ProfileModel({
    required this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.jobTitle = '',
    this.businessName = '',
    this.kraPin = '',
    this.businessType = '',
    this.county = '',
    this.isVerified = false,
  });

  // Override fromJson to handle type casting for id field
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? json['firstName']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? json['lastName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      jobTitle: json['job_title']?.toString() ?? json['jobTitle']?.toString() ?? '',
      businessName: json['business_name']?.toString() ?? json['businessName']?.toString() ?? '',
      kraPin: json['kra_pin']?.toString() ?? json['kraPin']?.toString() ?? '',
      businessType: json['business_type']?.toString() ?? json['businessType']?.toString() ?? '',
      county: json['county']?.toString() ?? '',
      isVerified: json['is_verified'] is bool ? json['is_verified'] : json['isVerified'] is bool ? json['isVerified'] : false,
    );
  }
  
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}