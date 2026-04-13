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

  ProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.jobTitle,
    required this.businessName,
    required this.kraPin,
    required this.businessType,
    required this.county,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
