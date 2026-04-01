import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/app_error_codes.dart';
import '../../../../core/network/app_error_mapper.dart';
import '../../../../core/network/api_exception.dart';
import '../models/story_item.dart';

class StoryApiService {
  StoryApiService(this._client);

  final http.Client _client;

  Future<List<StoryItem>> fetchStories({required String token}) async {
    try {
      final http.Response response = await _client
          .get(
            ApiConstants.buildUri('/stories'),
            headers: _authorizedHeaders(token),
          )
          .timeout(const Duration(seconds: 25));

      final Map<String, dynamic> data = _decode(response);

      if (response.statusCode == 200 && data['error'] == false) {
        final List<dynamic> rawList =
            (data['listStory'] as List<dynamic>?) ?? <dynamic>[];

        final List<StoryItem> stories =
            rawList
                .whereType<Map<String, dynamic>>()
                .map(StoryItem.fromJson)
                .toList()
              ..sort(
                (StoryItem a, StoryItem b) =>
                    b.createdAt.compareTo(a.createdAt),
              );

        return stories;
      }

      throw ApiException(
        _mapStoryStatusCode(response.statusCode),
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw ApiException(AppErrorCodes.noInternet);
    } on http.ClientException {
      throw ApiException(AppErrorCodes.serviceUnavailable);
    } on TimeoutException {
      throw ApiException(AppErrorCodes.requestTimeout);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(AppErrorCodes.unknown);
    }
  }

  Future<StoryItem> fetchStoryDetail({
    required String token,
    required String storyId,
  }) async {
    try {
      final http.Response response = await _client
          .get(
            ApiConstants.buildUri('/stories/$storyId'),
            headers: _authorizedHeaders(token),
          )
          .timeout(const Duration(seconds: 25));

      final Map<String, dynamic> data = _decode(response);

      if (response.statusCode == 200 && data['error'] == false) {
        final Object? storyRaw = data['story'];
        if (storyRaw is Map<String, dynamic>) {
          return StoryItem.fromJson(storyRaw);
        }
      }

      throw ApiException(
        _mapStoryStatusCode(response.statusCode),
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw ApiException(AppErrorCodes.noInternet);
    } on http.ClientException {
      throw ApiException(AppErrorCodes.serviceUnavailable);
    } on TimeoutException {
      throw ApiException(AppErrorCodes.requestTimeout);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(AppErrorCodes.unknown);
    }
  }

  Future<void> addStory({
    required String token,
    required String description,
    required String photoPath,
    double? lat,
    double? lon,
  }) async {
    try {
      final http.MultipartRequest request =
          http.MultipartRequest('POST', ApiConstants.buildUri('/stories'))
            ..headers.addAll(<String, String>{'Authorization': 'Bearer $token'})
            ..fields['description'] = description;

      if (lat != null && lon != null) {
        request.fields['lat'] = lat.toString();
        request.fields['lon'] = lon.toString();
      }

      request.files.add(await http.MultipartFile.fromPath('photo', photoPath));

      final http.StreamedResponse streamedResponse = await _client
          .send(request)
          .timeout(const Duration(seconds: 35));
      final http.Response response = await http.Response.fromStream(
        streamedResponse,
      );

      final Map<String, dynamic> data = _decode(response);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['error'] == false) {
        return;
      }

      throw ApiException(
        _mapStoryStatusCode(response.statusCode),
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw ApiException(AppErrorCodes.noInternet);
    } on http.ClientException {
      throw ApiException(AppErrorCodes.serviceUnavailable);
    } on TimeoutException {
      throw ApiException(AppErrorCodes.requestTimeout);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(AppErrorCodes.unknown);
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    try {
      final Object? decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } on FormatException {
      throw ApiException(AppErrorCodes.server, statusCode: response.statusCode);
    }

    throw ApiException(AppErrorCodes.server, statusCode: response.statusCode);
  }

  Map<String, String> _authorizedHeaders(String token) => <String, String>{
    'Authorization': 'Bearer $token',
  };

  String _mapStoryStatusCode(int statusCode) {
    if (statusCode == 401) {
      return AppErrorCodes.sessionExpired;
    }

    return AppErrorMapper.fromStatusCode(statusCode);
  }
}
