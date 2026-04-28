import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String id;
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String phone;
  @JsonKey(name: 'job_title')
  final String jobTitle;
  @JsonKey(name: 'business_name')
  final String businessName;
  @JsonKey(name: 'kra_pin')
  final String kraPin;
  @JsonKey(name: 'business_type')
  final String businessType;
  final String county;
  @JsonKey(name: 'is_verified')
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: (json['id'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      jobTitle: (json['job_title'] as String?) ?? '',
      businessName: (json['business_name'] as String?) ?? '',
      kraPin: (json['kra_pin'] as String?) ?? '',
      businessType: (json['business_type'] as String?) ?? '',
      county: (json['county'] as String?) ?? '',
      isVerified: (json['is_verified'] as bool?) ?? false,
    );
  }
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
