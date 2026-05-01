import 'package:flutter/material.dart';
import '../models/reminder_model.dart';
import '../models/notification_model.dart';
import '../providers/dashboard_provider.dart';
import '../services/notification_service.dart';
import '../utils/error_handler.dart';

class ReminderProvider with ChangeNotifier {
  final DashboardProvider _dashboardProvider;
  final NotificationService _notificationService;
  
  List<ReminderModel> _reminders = [];
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;
  String? _filterType; // 'all', 'expiry', 'notification'

  ReminderProvider(this._dashboardProvider, this._notificationService);

  List<ReminderModel> get reminders => _reminders;
  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get filterType => _filterType;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loadReminders() async {
    try {
      _setLoading(true);
      // Load dashboard summary which contains upcoming expiries
      await _dashboardProvider.fetchSummary();
      final summary = _dashboardProvider.summary;
      if (summary != null) {
        _reminders = summary.upcomingExpiries;
      } else {
        _reminders = [];
      }
      
      // Load compliance notifications
      _notifications = await _notificationService.getNotifications();
      
      _error = null;
    } catch (e) {
      _error = getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  void setFilter(String type) {
    _filterType = type;
    notifyListeners();
  }

  Future<void> markNotificationAsRead(String id) async {
    try {
      await _notificationService.markAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = AppNotification(
          id: _notifications[index].id,
          title: _notifications[index].title,
          message: _notifications[index].message,
          type: _notifications[index].type,
          createdAt: _notifications[index].createdAt,
          isRead: true,
          documentId: _notifications[index].documentId,
        );
      }
      notifyListeners();
    } catch (e) {
      _error = getErrorMessage(e);
    }
  }
}
