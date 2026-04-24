import '../models/profile_model.dart';
import 'base_service.dart';

class ProfileService extends BaseService {
  ProfileService(super.dio);

  Future<ProfileModel> getProfile() async {
    return get('/api/profile/', (data) => ProfileModel.fromJson(data));
  }

  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    return put('/api/profile/', data, (data) => ProfileModel.fromJson(data));
  }
}
