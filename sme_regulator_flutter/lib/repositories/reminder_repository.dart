import '../models/reminder_model.dart';
import '../services/reminders_service.dart';

class ReminderRepository {
  ReminderRepository(this._remindersService);

  final RemindersService _remindersService;

  Future<List<ReminderModel>> getReminders() => _remindersService.fetchReminders();

  Future<ReminderModel> createReminder(Map<String, dynamic> data) =>
      _remindersService.createReminder(data);

  Future<ReminderModel> updateReminder(String id, Map<String, dynamic> data) =>
      _remindersService.updateReminder(id, data);

  Future<void> deleteReminder(String id) => _remindersService.deleteReminder(id);
}
