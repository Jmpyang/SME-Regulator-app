import '../models/reminder_model.dart';
import '../services/reminder_service.dart';

class ReminderRepository {
  final ReminderService _reminderService;

  ReminderRepository(this._reminderService);

  Future<List<ReminderModel>> getReminders() async {
    return await _reminderService.fetchReminders();
  }

  Future<ReminderModel> createReminder(Map<String, dynamic> data) async {
    return await _reminderService.createReminder(data);
  }

  Future<ReminderModel> updateReminder(String id, Map<String, dynamic> data) async {
    return await _reminderService.updateReminder(id, data);
  }

  Future<void> deleteReminder(String id) async {
    return await _reminderService.deleteReminder(id);
  }
}
