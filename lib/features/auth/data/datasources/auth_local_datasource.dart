// auth_local_data_source.dart
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheUser(UserModel user) async {
    await HiveService.userBox.put(CacheConstants.userKey, user);
  }

  @override
  Future<UserModel> getCachedUser() async {
    final user = HiveService.userBox.get(CacheConstants.userKey);
    if (user != null) {
      return user as UserModel;
    } else {
      throw CacheException('No cached user found');
    }
  }

  @override
  Future<void> clearCache() async {
    await HiveService.clearUserSession();
  }
}