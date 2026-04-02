class ApiConfig {
  // Use http://10.0.2.2:8000 for Android emulator 
  // or http://localhost:8000 for iOS simulator / web
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Timeout thresholds
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
