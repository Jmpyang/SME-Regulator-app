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

  // Use the generated factory exclusively to respect @JsonKey and default values
  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}