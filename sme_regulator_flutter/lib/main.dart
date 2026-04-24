import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/document_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/knowledge_provider.dart';
import 'providers/theme_notifier.dart';
import 'providers/loading_provider.dart';

import 'services/api_client.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService();
  await apiService.init();

  final loadingProvider = LoadingProvider();
  
  final apiClient = ApiClient(prefs);
  final dio = apiClient.dio;

  final authService = AuthService(dio, TokenStorage(prefs));
  final documentService = DocumentService(dio);
  final remindersService = RemindersService(dio);
  final profileService = ProfileService(dio);
  final knowledgeService = KnowledgeService(dio);

  final authRepository = AuthRepository(authService);
  final documentRepository = DocumentRepository(documentService);
  final reminderRepository = ReminderRepository(remindersService);
  final dashboardService = DashboardService(dio);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => DocumentProvider(documentRepository)),
        ChangeNotifierProvider(create: (_) => ReminderProvider(reminderRepository)),
        ChangeNotifierProvider(create: (_) => DashboardProvider(dashboardService, loadingProvider)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(profileService)),
        ChangeNotifierProvider(create: (_) => KnowledgeProvider(knowledgeService)),
        ChangeNotifierProvider(create: (_) => ThemeNotifier(prefs)),
        ChangeNotifierProvider.value(value: loadingProvider),
      ],
      child: const SmeRegulatorApp(),
    ),
  );
}
