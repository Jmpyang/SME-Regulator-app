import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'routes/app_routes.dart';
import 'utils/performance_utils.dart';
import 'core/theme.dart';

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) => MaterialApp(
        title: 'SME Compliance Navigator',
        themeMode: themeProvider.themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: AppRoutes.landing,
        routes: AppRoutes.getRoutes(),
        scrollBehavior: const OptimizedScrollBehavior(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0), // Prevents text scaling issues
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
