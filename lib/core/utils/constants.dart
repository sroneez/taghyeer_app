class ApiUrls {
  static const String baseUrl = 'https://dummyjson.com';

  static const String login = '/auth/login';
  static const String products = '/products';
  static const String posts = '/posts';

  static const int connectionTimeout = 60000;
  static const int receiveTimeout = 60000;
}

class AppConstants {
  static const String bearerToken = 'bearer_token';
  static const String userId = 'user_id';
}

class CacheConstants {
  static const String userBox = 'user_box';
  static const String userKey = 'cached_user';
  static const String themeKey = 'is_dark_mode';
}