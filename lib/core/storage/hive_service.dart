import 'package:hive_flutter/hive_flutter.dart';
import '../../features/auth/data/models/user_model.dart';
import '../utils/constants.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserModelAdapter());

    await Hive.openBox(CacheConstants.userBox);
  }

  static Box get userBox => Hive.box(CacheConstants.userBox);

  static Future<void> clearUserSession() async {
    await userBox.clear();
  }
}
