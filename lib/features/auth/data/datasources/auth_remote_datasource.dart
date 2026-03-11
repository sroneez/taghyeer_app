// auth_remote_data_source.dart
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await apiClient.post(
      ApiUrls.login,
      body: {
        'username': username,
        'password': password,
        'expiresInMins': 30, // Required by DummyJSON API
      },
    );
    return UserModel.fromJson(response);
  }
}