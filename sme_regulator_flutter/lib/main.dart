import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/document_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/knowledge_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/loading_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/document_service.dart';
import 'services/reminders_service.dart';
import 'services/dashboard_service.dart';
import 'services/profile_service.dart';
import 'services/knowledge_service.dart';

import 'repositories/auth_repository.dart';
import 'repositories/document_repository.dart';
import 'repositories/reminder_repository.dart';
import 'utils/token_storage.dart';
import 'config/app_config.dart';

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

  final loadingProvider = LoadingProvider();
  
  // Use the new ApiService with Dio
  final dio = apiService.dio;

  final tokenStorage = TokenStorage(const FlutterSecureStorage());
  final authService = AuthService(dio, tokenStorage);
  final documentService = DocumentService(dio);
  final remindersService = RemindersService(dio);
  final profileService = ProfileService(dio);
  final knowledgeService = KnowledgeService(dio);

  final authRepository = AuthRepository(authService);
  final documentRepository = DocumentRepository(documentService);
  final reminderRepository = ReminderRepository(remindersService);
  final dashboardService = DashboardService(dio);

  final authProvider = AuthProvider(authRepository);
  await tryAutoLogin(authProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => DocumentProvider(documentRepository)),
        ChangeNotifierProvider(create: (_) => ReminderProvider(reminderRepository)),
        ChangeNotifierProvider(create: (_) => DashboardProvider(dashboardService, loadingProvider)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(profileService)),
        ChangeNotifierProvider(create: (_) => KnowledgeProvider(knowledgeService)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: loadingProvider),
      ],
      child: const SmeRegulatorApp(),
    ),
  );
}
