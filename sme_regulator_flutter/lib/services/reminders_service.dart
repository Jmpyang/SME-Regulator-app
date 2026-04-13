import 'package:dio/dio.dart';

import '../models/reminder_model.dart';
import '../utils/api_parsers.dart';

class RemindersService {
  RemindersService(this._dio);

  final Dio _dio;

  Future<List<ReminderModel>> fetchReminders() async {
    final response = await _dio.get('/reminders');
    return decodeList(response.data).map((e) => parseReminder(e)).toList();
  }

  Future<ReminderModel> createReminder(Map<String, dynamic> data) async {
    final response = await _dio.post<dynamic>('/reminders', data: data);
    return parseReminder(decodeMap(response.data));
  }

  Future<ReminderModel> updateReminder(String id, Map<String, dynamic> data) async {
    final response = await _dio.put<dynamic>('/api/reminders/$id', data: data);
    return parseReminder(decodeMap(response.data));
  }

  Future<void> deleteReminder(String id) async {
    await _dio.delete('/reminders/$id');
  }
}
