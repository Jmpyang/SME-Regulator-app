import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'providers/auth_provider.dart';
import 'repositories/auth_repository.dart';

import 'services/api_service.dart';
import 'services/auth_service.dart';

import 'utils/token_storage.dart';
import 'app.dart';

Future<void> tryAutoLogin(AuthProvider auth) async {
  try {
    final token = await const FlutterSecureStorage().read(key: 'access_token');
    if (token == null) return; // show login screen

    final apiService = ApiService();
    apiService.initialize();
    final dio = apiService.dio;
    try {
      // Validate token by hitting a lightweight endpoint
      await dio.get('/api/profile/');
      // Token is valid, AuthProvider will handle user state through checkAuthStatus
    } catch (_) {
      // Token expired or invalid — send to login
      await const FlutterSecureStorage().deleteAll();
    }
  } catch (_) {
    // Keyring unavailable or locked — skip auto-login silently
    return;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  apiService.initialize();

  final dio = apiService.dio;

  final tokenStorage = TokenStorage(const FlutterSecureStorage());
  final authService = AuthService(dio, tokenStorage);
  final authRepository = AuthRepository(authService);
  final authProvider = AuthProvider(authRepository);
  await tryAutoLogin(authProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: SmeRegulatorApp(),
    ),
  );
}
