import 'package:flutter/foundation.dart';

class LoadingProvider extends ChangeNotifier {
  final Map<String, bool> _loadingStates = {};
  final Map<String, String> _loadingMessages = {};

  bool isLoading(String key) => _loadingStates[key] ?? false;
  String? getLoadingMessage(String key) => _loadingMessages[key];

  void setLoading(String key, bool loading, {String? message}) {
    if (_loadingStates[key] != loading) {
      _loadingStates[key] = loading;
      if (message != null) {
        _loadingMessages[key] = message;
      } else if (!loading) {
        _loadingMessages.remove(key);
      }
      notifyListeners();
    }
  }

  void clearLoading(String key) {
    if (_loadingStates.containsKey(key)) {
      _loadingStates.remove(key);
      _loadingMessages.remove(key);
      notifyListeners();
    }
  }

  void clearAllLoading() {
    if (_loadingStates.isNotEmpty) {
      _loadingStates.clear();
      _loadingMessages.clear();
      notifyListeners();
    }
  }

  bool get hasAnyLoading => _loadingStates.values.any((loading) => loading);
}

class LoadingManager {
  static final LoadingManager _instance = LoadingManager._internal();
  factory LoadingManager() => _instance;
  LoadingManager._internal();

  final Map<String, VoidCallback> _operations = {};

  String startOperation(VoidCallback operation, {String? operationKey}) {
    final key = operationKey ?? 'operation_${DateTime.now().millisecondsSinceEpoch}';
    _operations[key] = operation;
    return key;
  }

  void cancelOperation(String key) {
    _operations.remove(key);
  }

  void cancelAllOperations() {
    _operations.clear();
  }
}
