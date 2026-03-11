import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static late SharedPreferences _prefs;

  // Must be called in main.dart before runApp()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Strings (For Tokens & User IDs) ---
  static Future<String> getString(String key) async {
    return _prefs.getString(key) ?? '';
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // --- Booleans (For Theme Mode) ---
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    return _prefs.getBool(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // --- General ---
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}