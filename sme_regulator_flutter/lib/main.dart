import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/document_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/knowledge_provider.dart';
import 'providers/loading_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/document_repository.dart';
import 'services/dashboard_service.dart';
import 'services/document_service.dart';
import 'services/notification_service.dart';
import 'services/profile_service.dart';
import 'services/knowledge_service.dart';

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
      // Token is valid, set user state in AuthProvider
      await auth.checkAuthStatus();
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => DocumentProvider(DocumentRepository(DocumentService(dio)))),
        ChangeNotifierProvider(create: (_) => ProfileProvider(ProfileService(dio), authProvider)),
        ChangeNotifierProvider(create: (context) => DashboardProvider(DashboardService(dio), context.read<LoadingProvider>(), context.read<DocumentProvider>(), context.read<ProfileProvider>())),
        ChangeNotifierProvider(create: (context) => ReminderProvider(context.read<DashboardProvider>(), NotificationService(dio))),
        ChangeNotifierProvider(create: (_) => KnowledgeProvider(KnowledgeService(dio))),
      ],
      child: SmeRegulatorApp(),
    ),
  );
}
