import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:demo_project/core/config/environment.dart';
import 'package:demo_project/core/constants/app_constants.dart';
import 'package:demo_project/services/api_exception.dart';
import 'package:demo_project/services/connectivity_service.dart';
import 'package:demo_project/services/storage_service.dart';
import 'package:demo_project/core/utils/logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  final StorageService _storage = StorageService();
  final ConnectivityService _connectivity = ConnectivityService();

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _buildUri(String endpoint, {Map<String, dynamic>? queryParams}) {
    final uri = Uri.parse('${EnvironmentConfig.baseUrl}$endpoint');
    if (queryParams != null) {
      return uri.replace(queryParameters: queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      ));
    }
    return uri;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? extraHeaders,
  }) async {
    return _request(
      () => _client.get(
        _buildUri(endpoint, queryParams: queryParams),
        headers: {..._headers, ...?extraHeaders},
      ),
    );
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? extraHeaders,
  }) async {
    return _request(
      () => _client.post(
        _buildUri(endpoint),
        headers: {..._headers, ...?extraHeaders},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    Map<String, String>? extraHeaders,
  }) async {
    return _request(
      () => _client.put(
        _buildUri(endpoint),
        headers: {..._headers, ...?extraHeaders},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> patch(
    String endpoint, {
    dynamic body,
    Map<String, String>? extraHeaders,
  }) async {
    return _request(
      () => _client.patch(
        _buildUri(endpoint),
        headers: {..._headers, ...?extraHeaders},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? extraHeaders,
  }) async {
    return _request(
      () => _client.delete(
        _buildUri(endpoint),
        headers: {..._headers, ...?extraHeaders},
      ),
    );
  }

  Future<dynamic> _request(
    Future<http.Response> Function() request,
  ) async {
    if (!await _connectivity.hasConnection) {
      throw ApiException.noInternet();
    }
    try {
      final response = await request().timeout(
        Duration(seconds: AppConstants.connectTimeout),
      );

      AppLogger.network('=======> Method: ${response.request?.method} \n url : ${response.request?.url} \n  -----> status Code ${response.statusCode} \n ========> ${response.body} ');

      return _processResponse(response);
    } on TimeoutException {
      throw ApiException.timeout();
    } on SocketException {
      AppLogger.error('Socket error', error: request);
      throw ApiException(message: 'Could not connect to server');
    } on ApiException {
      rethrow;
    } catch (e) {
      AppLogger.error('Network error', error: e);
      throw ApiException.unknown(e);
    }
  }

  dynamic _processResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException.fromStatusCode(response.statusCode, body);
  }
}
