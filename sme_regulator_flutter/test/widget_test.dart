import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sme_regulator_flutter/app.dart';
import 'package:sme_regulator_flutter/providers/auth_provider.dart';
import 'package:sme_regulator_flutter/repositories/auth_repository.dart';
import 'package:sme_regulator_flutter/services/auth_service.dart';
import 'package:sme_regulator_flutter/utils/token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App renders smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final dio = Dio(BaseOptions());
    final dummyAuthService = AuthService(dio, TokenStorage(prefs));
    final dummyAuthRepository = AuthRepository(dummyAuthService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(dummyAuthRepository),
          ),
        ],
        child: const SmeRegulatorApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
