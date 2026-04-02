import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'routes/app_routes.dart';
import 'screens/auth/landing_screen.dart';
import 'screens/dashboard_screen.dart';

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
    return MaterialApp(
      title: 'SME Compliance Navigator',
      theme: ThemeData(
        primaryColor: const Color(0xFF5A4FCF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A4FCF),
          primary: const Color(0xFF5A4FCF),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter', // Default to a modern sans-serif like Inter if available, fallback implicitly
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF111827), // Almost black for the 'Get Started' button in the image
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
      ),
      initialRoute: AppRoutes.landing,
      routes: AppRoutes.getRoutes(),
    );
  }
}
