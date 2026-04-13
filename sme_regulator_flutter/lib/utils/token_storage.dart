import 'package:shared_preferences/shared_preferences.dart';

/// Persists the JWT for [ApiClient] interceptors and session restore.
class TokenStorage {
  TokenStorage(this._prefs);

  final SharedPreferences _prefs;

  static const String jwtKey = 'jwt_token';

  String? get accessToken => _prefs.getString(jwtKey);

  Future<void> setAccessToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _prefs.remove(jwtKey);
    } else {
      await _prefs.setString(jwtKey, token);
    }
  }
}
