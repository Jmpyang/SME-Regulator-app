import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:sme_regulator_flutter/app.dart';
import 'package:sme_regulator_flutter/providers/auth_provider.dart';
import 'package:sme_regulator_flutter/repositories/auth_repository.dart';
import 'package:sme_regulator_flutter/services/auth_service.dart';
import 'package:sme_regulator_flutter/services/http_client.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    // Setup a dummy AuthRepository for the test
    final dummyAuthService = AuthService(AppHttpClient().dio);
    final dummyAuthRepository = AuthRepository(dummyAuthService);

    // Build our app wrapped with providers and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(dummyAuthRepository),
          ),
          // Add other providers here if your app depends on them
        ],
        child: const SmeRegulatorApp(),
      ),
    );

    // Verify that the app is built
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
