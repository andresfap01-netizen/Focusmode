import 'dart:convert';

import 'package:focusmode/models/requests/RestrictionPatchRequest.dart';
import 'package:focusmode/models/requests/RestrictionSyncRequest.dart';
import 'package:focusmode/models/requests/UserCreateRequest.dart';
import 'package:focusmode/models/requests/UserLoginRequest.dart';
import 'package:focusmode/models/responses/RestrictionOutResponse.dart';
import 'package:focusmode/models/responses/TokenResponse.dart';
import 'package:focusmode/models/responses/UserOutResponse.dart';
import 'package:focusmode/models/responses/WeeklyStatsOutResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiException implements Exception {
  final String operation;
  final int statusCode;
  final String responseBody;

  const ApiException({
    required this.operation,
    required this.statusCode,
    required this.responseBody,
  });

  @override
  String toString() {
    return '$operation failed ($statusCode): $responseBody';
  }
}

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String _tokenKey = 'access_token';

  String? _token;

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _token = token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _token = null;
  }

  Future<bool> hasToken() async {
    await _loadToken();
    return _token != null && _token!.isNotEmpty;
  }

  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (includeAuth && _token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  ApiException _buildException(String operation, http.Response response) {
    return ApiException(
      operation: operation,
      statusCode: response.statusCode,
      responseBody: response.body,
    );
  }

  Future<Map<String, dynamic>> getHealth() async {
    final response = await http.get(Uri.parse('$baseUrl/health'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw _buildException('Health check', response);
  }

  Future<UserOutResponse> signUp(UserCreateRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return UserOutResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw _buildException('Signup', response);
  }

  Future<TokenResponse> login(UserLoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final token = TokenResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      await _saveToken(token.accessToken);
      return token;
    }

    throw _buildException('Login', response);
  }

  Future<UserOutResponse> getCurrentUser() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return UserOutResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw _buildException('Get current user', response);
  }

  Future<List<RestrictionOutResponse>> getRestrictions() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/restrictions'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (item) =>
                RestrictionOutResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    throw _buildException('Get restrictions', response);
  }

  Future<List<RestrictionOutResponse>> syncRestrictions(
    RestrictionSyncRequest request,
  ) async {
    await _loadToken();
    final response = await http.put(
      Uri.parse('$baseUrl/restrictions'),
      headers: _getHeaders(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map(
            (item) =>
                RestrictionOutResponse.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    throw _buildException('Sync restrictions', response);
  }

  Future<RestrictionOutResponse> updateRestriction(
    String appKey,
    RestrictionPatchRequest request,
  ) async {
    await _loadToken();
    final safeKey = Uri.encodeComponent(appKey);
    final response = await http.patch(
      Uri.parse('$baseUrl/restrictions/$safeKey'),
      headers: _getHeaders(),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return RestrictionOutResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw _buildException('Update restriction', response);
  }

  Future<void> deleteRestriction(String appKey) async {
    await _loadToken();
    final safeKey = Uri.encodeComponent(appKey);
    final response = await http.delete(
      Uri.parse('$baseUrl/restrictions/$safeKey'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw _buildException('Delete restriction', response);
    }
  }

  Future<WeeklyStatsOutResponse> getWeeklyStats() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/stats/weekly'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return WeeklyStatsOutResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw _buildException('Get weekly stats', response);
  }
}
