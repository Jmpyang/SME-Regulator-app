/// Base exception class for the SME Regulator app
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AppException(this.message, {this.code, this.originalError});
  
  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// File-related exceptions
class FileException extends AppException {
  const FileException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// Unknown exceptions
class UnknownException extends AppException {
  const UnknownException(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}
