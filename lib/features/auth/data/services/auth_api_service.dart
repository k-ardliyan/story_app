import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_exception.dart';
import '../models/auth_session.dart';

class AuthApiService {
  AuthApiService(this._client);

  final http.Client _client;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final http.Response response = await _client
          .post(
            ApiConstants.buildUri('/register'),
            headers: _jsonHeaders,
            body: jsonEncode(<String, String>{
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 25));

      final Map<String, dynamic> data = _decode(response);

      if (response.statusCode == 201 && data['error'] == false) {
        return;
      }

      throw ApiException(
        (data['message'] as String?) ?? 'Failed to register account.',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      throw ApiException('Connection timed out. Please try again.');
    }
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final http.Response response = await _client
          .post(
            ApiConstants.buildUri('/login'),
            headers: _jsonHeaders,
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 25));

      final Map<String, dynamic> data = _decode(response);

      if (response.statusCode == 200 && data['error'] == false) {
        final Object? result = data['loginResult'];
        if (result is Map<String, dynamic>) {
          final AuthSession session = AuthSession.fromLoginResult(result);
          if (session.isValid) {
            return session;
          }
        }
      }

      throw ApiException(
        (data['message'] as String?) ?? 'Failed to login.',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      throw ApiException('Connection timed out. Please try again.');
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final Object? decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      throw ApiException('Unexpected server response.');
    }

    throw ApiException('Unexpected server response.');
  }

  Map<String, String> get _jsonHeaders => <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
