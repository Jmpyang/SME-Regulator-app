import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromProfileMap(Map<String, dynamic> json) {
    final fn = json['first_name']?.toString() ?? '';
    final ln = json['last_name']?.toString() ?? '';
    final combined = '$fn $ln'.trim();
    
    return UserModel(
      id: json['id']?.toString() ?? json['sub']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: combined.isEmpty ? (json['name']?.toString() ?? json['email']?.toString() ?? 'User') : combined,
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }
}