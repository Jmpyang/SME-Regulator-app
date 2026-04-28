import 'dart:async';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _service;
  
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;
  Timer? _syncTimer;

  NotificationProvider(this._service);

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    try {
      _setLoading(true);
      _notifications = await _service.getNotifications();
      _error = null;
    } catch (e) {
      _error = 'Failed to load notifications';
    } finally {
      _setLoading(false);
    }
  }

  void startSync() {
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchNotifications(); // re-fetch silently in background
    });
  }

  void stopSync() => _syncTimer?.cancel();

  Future<void> fetchNotifications() async {
    try {
      _notifications = await _service.getNotifications();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch notifications';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopSync();
    super.dispose();
  }
}
