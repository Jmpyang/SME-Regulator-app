import 'package:flutter/material.dart';
import '../screens/auth/landing_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/verify_otp_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/document_vault_screen.dart';
import '../screens/permits_screen.dart';
import '../screens/reminders_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings/change_password_screen.dart';

class AppRoutes {
  static const landing = '/';
  static const login = '/login';
  static const register = '/register';
  static const verifyOtp = '/verify-otp';
  static const verifyResetOtp = '/verify-reset-otp';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const documentVault = '/document-vault';
  static const permits = '/permits';
  static const reminders = '/reminders';
  static const profile = '/profile';
  static const changePassword = '/change-password';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      landing: (context) => const LandingScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      verifyOtp: (context) => const VerifyOTPScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      resetPassword: (context) => const ResetPasswordScreen(),
      dashboard: (context) => const DashboardScreen(),
      documentVault: (context) => const DocumentVaultScreen(),
      permits: (context) => const PermitsScreen(),
      reminders: (context) => const RemindersScreen(),
      profile: (context) => const ProfileScreen(),
      changePassword: (context) => const ChangePasswordScreen(),
    };
  }
}
