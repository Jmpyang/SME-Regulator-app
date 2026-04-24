import '../models/reminder_model.dart';
import '../utils/api_parsers.dart';
import 'base_service.dart';

class RemindersService extends BaseService {
  RemindersService(super.dio);

  Future<List<ReminderModel>> fetchReminders() async {
    return getList('/api/reminders', parseReminder);
  }

  Future<ReminderModel> createReminder(Map<String, dynamic> data) async {
    return post('/api/reminders', data, parseReminder);
  }

  Future<ReminderModel> updateReminder(String id, Map<String, dynamic> data) async {
    return put('/api/reminders/$id', data, parseReminder);
  }

  Future<void> deleteReminder(String id) async {
    await delete('/api/reminders/$id');
  }
}
