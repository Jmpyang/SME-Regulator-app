import 'package:dio/dio.dart';
import '../models/reminder_model.dart';

class ReminderService {
  final Dio _dio;

  ReminderService(this._dio);

  Future<List<ReminderModel>> fetchReminders() async {
    final response = await _dio.get('/reminders');
    final data = response.data as List;
    return data.map((e) => ReminderModel.fromJson(e)).toList();
  }

  Future<ReminderModel> createReminder(Map<String, dynamic> data) async {
    final response = await _dio.post('/reminders', data: data);
    return ReminderModel.fromJson(response.data);
  }

  Future<ReminderModel> updateReminder(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/reminders/$id', data: data);
    return ReminderModel.fromJson(response.data);
  }

  Future<void> deleteReminder(String id) async {
    await _dio.delete('/reminders/$id');
  }
}
