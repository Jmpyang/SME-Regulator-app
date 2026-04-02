import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<UserModel> login(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<void> register(Map<String, dynamic> data) async {
    return await _authService.register(data);
  }

  Future<void> verifyOtp(String email, String otp) async {
    return await _authService.verifyOtp(email, otp);
  }

  Future<void> forgotPassword(String email) async {
    return await _authService.forgotPassword(email);
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    return await _authService.resetPassword(email, otp, newPassword);
  }

  Future<UserModel> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }
}
