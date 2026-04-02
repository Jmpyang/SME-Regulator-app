import 'package:flutter/material.dart';
import '../models/reminder_model.dart';
import '../repositories/reminder_repository.dart';

class ReminderProvider with ChangeNotifier {
  final ReminderRepository _repository;
  
  List<ReminderModel> _reminders = [];
  bool _isLoading = false;
  String? _error;

  ReminderProvider(this._repository);

  List<ReminderModel> get reminders => _reminders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> loadReminders() async {
    try {
      _setLoading(true);
      _reminders = await _repository.getReminders();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addReminder(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      final reminder = await _repository.createReminder(data);
      _reminders.add(reminder);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> markAsCompleted(String id) async {
    try {
      _setLoading(true);
      final reminder = await _repository.updateReminder(id, {'completed': true});
      final index = _reminders.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reminders[index] = reminder;
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
