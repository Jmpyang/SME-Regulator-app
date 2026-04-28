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
    try {
      final fn = json['first_name']?.toString() ?? '';
      final ln = json['last_name']?.toString() ?? '';
      final combined = '$fn $ln'.trim();
      final email = json['email']?.toString() ?? '';
      final id = json['id']?.toString() ?? json['sub']?.toString() ?? '';
      final phone = json['phone']?.toString() ?? json['mobile']?.toString() ?? '';
      final role = json['role']?.toString() ?? json['user_type']?.toString() ?? 'user';
      
      return UserModel(
        id: id,
        email: email,
        name: combined.isEmpty ? (json['name']?.toString() ?? email) : combined,
        phone: phone,
        role: role,
      );
    } catch (e) {
      // Fallback for any parsing errors
      return UserModel(
        id: json['id']?.toString() ?? json['sub']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        name: json['name']?.toString() ?? json['email']?.toString() ?? 'User',
        phone: json['phone']?.toString() ?? '',
        role: json['role']?.toString() ?? 'user',
      );
    }
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
