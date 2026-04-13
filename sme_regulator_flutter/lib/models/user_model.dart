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

  /// Map FastAPI [GET /profile] (or login payload) when fields use snake_case.
  factory UserModel.fromProfileMap(Map<String, dynamic> json) {
    final fn = json['first_name'] as String? ?? '';
    final ln = json['last_name'] as String? ?? '';
    final combined = '$fn $ln'.trim();
    final email = json['email'] as String? ?? '';
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: email,
      name: combined.isEmpty ? (json['name'] as String? ?? email) : combined,
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
