import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT for [ApiClient] interceptors and session restore.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String jwtKey = 'access_token';

  Future<String?> get accessToken async => await _storage.read(key: jwtKey);

  Future<void> setAccessToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _storage.delete(key: jwtKey);
    } else {
      await _storage.write(key: jwtKey, value: token);
    }
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
