import 'package:dio/dio.dart';

import '../models/profile_model.dart';
import '../utils/api_parsers.dart';

class ProfileService {
  ProfileService(this._dio);

  final Dio _dio;

  Future<ProfileModel> getProfile() async {
    final response = await _dio.get('/api/profile/');
    return ProfileModel.fromJson(decodeMap(response.data));
  }

  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _dio.put('/api/profile/', data: data);
    return ProfileModel.fromJson(decodeMap(response.data));
  }
}
