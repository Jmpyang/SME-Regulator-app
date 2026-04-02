import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/document_provider.dart';
import 'providers/reminder_provider.dart';
import 'services/auth_service.dart';
import 'services/document_service.dart';
import 'services/reminder_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/document_repository.dart';
import 'repositories/reminder_repository.dart';
import 'services/http_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize generic preferences
  final prefs = await SharedPreferences.getInstance();
  
  // Setup DI / Services
  final httpClient = AppHttpClient();
  final dio = httpClient.dio;
  
  final authService = AuthService(dio);
  final documentService = DocumentService(dio);
  final reminderService = ReminderService(dio);
  
  final authRepository = AuthRepository(authService);
  final documentRepository = DocumentRepository(documentService);
  final reminderRepository = ReminderRepository(reminderService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => DocumentProvider(documentRepository)),
        ChangeNotifierProvider(create: (_) => ReminderProvider(reminderRepository)),
      ],
      child: const SmeRegulatorApp(),
    ),
  );
}
