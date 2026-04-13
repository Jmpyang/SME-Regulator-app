import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/theme_notifier.dart';
import 'routes/app_routes.dart';
import 'utils/performance_utils.dart';

class SmeRegulatorApp extends StatefulWidget {
  const SmeRegulatorApp({super.key});

  @override
  State<SmeRegulatorApp> createState() => _SmeRegulatorAppState();
}

class _SmeRegulatorAppState extends State<SmeRegulatorApp> {
  @override
  void initState() {
    super.initState();
    // Attempt auto-login using stored token
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF5A4FCF),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5A4FCF),
        primary: const Color(0xFF5A4FCF),
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Inter',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF111827),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF5A4FCF),
        ),
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5A4FCF),
        primary: const Color(0xFF8B83FF),
        brightness: Brightness.dark,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Inter',
    );

    return MaterialApp(
      title: 'SME Compliance Navigator',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: theme.themeMode,
      initialRoute: AppRoutes.landing,
      routes: AppRoutes.getRoutes(),
      scrollBehavior: const OptimizedScrollBehavior(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0), // Prevents text scaling issues
          ),
          child: child!,
        );
      },
    );
  }
}
