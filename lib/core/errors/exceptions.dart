// Location: lib/core/error/exceptions.dart

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'An unknown server error occurred.']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'A local storage error occurred.']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection.']);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Session expired. Please log in again.']);
}