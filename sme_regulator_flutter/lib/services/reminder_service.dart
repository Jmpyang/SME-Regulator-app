import '../models/reminder_model.dart';
import 'base_service.dart';

class ReminderService extends BaseService {
  ReminderService(super.dio);

  Future<List<ReminderModel>> fetchReminders() async {
    return getList('/api/reminders', (data) => ReminderModel.fromJson(data));
  }

  Future<ReminderModel> createReminder(Map<String, dynamic> reminderData) async {
    return post('/api/reminders', reminderData, (data) => ReminderModel.fromJson(data));
  }

  Future<ReminderModel> updateReminder(String id, Map<String, dynamic> reminderData) async {
    return put('/api/reminders/$id', reminderData, (data) => ReminderModel.fromJson(data));
  }

  Future<void> deleteReminder(String id) async {
    await delete('/api/reminders/$id');
  }
}
