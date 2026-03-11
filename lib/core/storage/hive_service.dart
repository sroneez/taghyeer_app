import 'package:hive_flutter/hive_flutter.dart';
import '../utils/constants.dart';

class HiveService {
  // Must be called in main.dart before runApp()
  static Future<void> init() async {
    await Hive.initFlutter();

    // NOTE: We will register the UserModelAdapter here later once we create it in the Auth feature!
    // Hive.registerAdapter(UserModelAdapter());

    // Open the box for caching user data
    await Hive.openBox(CacheConstants.userBox);
  }

  // Quick accessor for the User Box
  static Box get userBox => Hive.box(CacheConstants.userBox);

  // Clears the user box on logout
  static Future<void> clearUserSession() async {
    await userBox.clear();
  }
}