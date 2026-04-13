import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// API configuration for the FastAPI backend.
///
/// Desktop / iOS simulator / web: `http://127.0.0.1:8000` (incl. Linux).
/// Android emulator: `http://10.0.2.2:8000`.
class AppConfig {
  AppConfig._();

  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000';
      default:
        return 'http://127.0.0.1:8000';
    }
  }

  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}
