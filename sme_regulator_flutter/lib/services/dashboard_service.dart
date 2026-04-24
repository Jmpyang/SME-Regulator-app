import '../models/dashboard_summary_model.dart';
import 'base_service.dart';

class DashboardService extends BaseService {
  DashboardService(super.dio);

  Future<DashboardSummaryModel> fetchDashboardSummary() async {
    return get('/api/dashboard/summary', (data) => DashboardSummaryModel.fromJson(data));
  }
}
