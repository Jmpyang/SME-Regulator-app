import '../models/reminder_model.dart';
import '../services/reminder_service.dart';

class ReminderRepository {
  ReminderRepository(this._reminderService);

  final ReminderService _reminderService;

  Future<List<ReminderModel>> getReminders() => _reminderService.fetchReminders();

  Future<ReminderModel> createReminder(Map<String, dynamic> data) =>
      _reminderService.createReminder(data);

  Future<ReminderModel> updateReminder(String id, Map<String, dynamic> data) =>
      _reminderService.updateReminder(id, data);

  Future<void> deleteReminder(String id) => _reminderService.deleteReminder(id);
}
