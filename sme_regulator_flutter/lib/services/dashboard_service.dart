import 'package:dio/dio.dart';

import '../models/dashboard_summary_model.dart';
import '../utils/api_parsers.dart';

class DashboardService {
  DashboardService(this._dio);

  final Dio _dio;

  Future<DashboardSummaryModel> fetchDashboardSummary() async {
    final response = await _dio.get('/api/dashboard/summary');
    return DashboardSummaryModel.fromJson(decodeMap(response.data));
  }
}
