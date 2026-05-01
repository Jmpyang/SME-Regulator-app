import 'dart:async';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
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
  
  // Helper getter for unread count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    _setLoading(true);
    await fetchNotifications();
    _setLoading(false);
  }

  void startSync() {
    _syncTimer?.cancel(); // Clear existing timers
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchNotifications(); 
    });
  }

  Future<void> fetchNotifications() async {
    try {
      final results = await _service.getNotifications();
      _notifications = results;
      _error = null;
    } catch (e) {
      _error = 'Failed to sync notifications';
    } finally {
      notifyListeners();
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _service.markAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        // Optimistic UI update
        _notifications[index] = AppNotification(
          id: _notifications[index].id,
          title: _notifications[index].title,
          message: _notifications[index].message,
          type: _notifications[index].type,
          createdAt: _notifications[index].createdAt,
          isRead: true,
          documentId: _notifications[index].documentId,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = 'Could not update notification status';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}