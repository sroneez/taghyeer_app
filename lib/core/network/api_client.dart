import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:taghyeer_app/core/errors/exceptions.dart';
import 'package:taghyeer_app/core/storage/prefs_helper.dart';
import 'package:taghyeer_app/core/utils/constants.dart';


import '../helpers/logger.dart';

final log = logger(ApiClient);

class ApiClient {
  final http.Client _client;
  static const int timeoutInSeconds = 60;

  ApiClient({required http.Client client}) : _client = client;

  Future<Map<String, String>> _getHeaders({Map<String, String>? customHeaders}) async {
    final token = await PrefsHelper.getString(AppConstants.bearerToken);
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    log.i('📥 Response [$statusCode]: ${_formatJsonForLogging(body)}');

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) return {};
      return jsonDecode(body);
    }

    // Handle specific error codes cleanly
    if (statusCode == 401) {
      PrefsHelper.remove(AppConstants.bearerToken);
      PrefsHelper.remove(AppConstants.userId);
      // NOTE: Your BLoC or a global auth listener should intercept this exception and route to login.
      throw UnauthorizedException('Session expired. Please log in again.');
    }

    String errorMessage = 'Something went wrong';
    try {
      final errorBody = jsonDecode(body);
      errorMessage = errorBody['message'] ?? errorBody['error'] ?? response.reasonPhrase ?? errorMessage;

      if (statusCode == 500 && errorBody['message'] == 'jwt expired') {
        PrefsHelper.remove(AppConstants.bearerToken);
        throw UnauthorizedException('Session expired.');
      }
    } catch (_) {
      errorMessage = body.isNotEmpty ? body : response.reasonPhrase ?? errorMessage;
    }

    throw ServerException(errorMessage);
  }

  Future<dynamic> get(String uri, {Map<String, String>? headers, Map<String, dynamic>? queryParams}) async {
    try {
      final finalUri = Uri.parse(ApiUrls.baseUrl + uri).replace(queryParameters: queryParams);
      final requestHeaders = await _getHeaders(customHeaders: headers);

      log.i('🌐 GET: $finalUri');
      log.i('🔧 Headers: $requestHeaders');

      final response = await _client
          .get(finalUri, headers: requestHeaders)
          .timeout(const Duration(seconds: timeoutInSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw ServerException('Request timed out');
    }
  }

  Future<dynamic> post(String uri, {required dynamic body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse(ApiUrls.baseUrl + uri);
      final requestHeaders = await _getHeaders(customHeaders: headers);

      log.i('🌐 POST: $url');
      log.i('📦 Body: ${_formatJsonForLogging(body)}');

      final response = await _client
          .post(url, body: jsonEncode(body), headers: requestHeaders)
          .timeout(const Duration(seconds: timeoutInSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw ServerException('Request timed out');
    }
  }

  Future<dynamic> put(String uri, {required dynamic body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse(ApiUrls.baseUrl + uri);
      final requestHeaders = await _getHeaders(customHeaders: headers);

      log.i('🌐 PUT: $url');
      log.i('📦 Body: ${_formatJsonForLogging(body)}');

      final response = await _client
          .put(url, body: jsonEncode(body), headers: requestHeaders)
          .timeout(const Duration(seconds: timeoutInSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw ServerException('Request timed out');
    }
  }

  Future<dynamic> patch(String uri, {required dynamic body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse(ApiUrls.baseUrl + uri);
      final requestHeaders = await _getHeaders(customHeaders: headers);

      log.i('🌐 PATCH: $url');
      log.i('📦 Body: ${_formatJsonForLogging(body)}');

      final response = await _client
          .patch(url, body: jsonEncode(body), headers: requestHeaders)
          .timeout(const Duration(seconds: timeoutInSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw ServerException('Request timed out');
    }
  }

  Future<dynamic> delete(String uri, {dynamic body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse(ApiUrls.baseUrl + uri);
      final requestHeaders = await _getHeaders(customHeaders: headers);

      log.i('🌐 DELETE: $url');
      if (body != null) log.i('📦 Body: ${_formatJsonForLogging(body)}');

      final response = await _client
          .delete(url, body: body != null ? jsonEncode(body) : null, headers: requestHeaders)
          .timeout(const Duration(seconds: timeoutInSeconds));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw ServerException('Request timed out');
    }
  }

  Future<dynamic> postMultipart(
      String uri,
      Map<String, String> body, {
        required List<MultipartBody> multipartBody,
        Map<String, String>? headers,
      }) async {
    try {
      final url = Uri.parse(ApiUrls.baseUrl + uri);
      var requestHeaders = await _getHeaders(customHeaders: headers);
      requestHeaders.remove('Content-Type');

      log.i('🌐 POST MULTIPART: $url');
      log.i('📦 Fields: $body');

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(requestHeaders);
      request.fields.addAll(body);

      for (var element in multipartBody) {
        if (await element.file.exists()) {
          String? mimeType = mime(element.file.path);
          if (mimeType != null) {
            request.files.add(
              await http.MultipartFile.fromPath(
                element.key,
                element.file.path,
                contentType: MediaType.parse(mimeType),
              ),
            );
          }
        }
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: timeoutInSeconds));
      final response = await http.Response.fromStream(streamedResponse);

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw ServerException('Request timed out');
    }
  }

  String _formatJsonForLogging(dynamic data) {
    if (data == null || data.toString().isEmpty) return '';
    try {
      if (data is String) return const JsonEncoder.withIndent('  ').convert(jsonDecode(data));
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }
}

class MultipartBody {
  final String key;
  final File file;

  MultipartBody(this.key, this.file);
}