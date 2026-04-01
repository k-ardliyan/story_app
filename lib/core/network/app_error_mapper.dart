import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'app_error_codes.dart';

class AppErrorMapper {
  static String toCode(Object error) {
    if (error is ApiException) {
      final String message = error.message.trim();
      if (AppErrorCodes.all.contains(message)) {
        return message;
      }

      if (error.statusCode != null) {
        return fromStatusCode(error.statusCode!);
      }

      return AppErrorCodes.unknown;
    }

    if (error is SocketException) {
      return AppErrorCodes.noInternet;
    }

    if (error is TimeoutException) {
      return AppErrorCodes.requestTimeout;
    }

    if (error is http.ClientException) {
      return AppErrorCodes.serviceUnavailable;
    }

    return AppErrorCodes.unknown;
  }

  static String fromStatusCode(int statusCode) {
    if (statusCode == 400 || statusCode == 409 || statusCode == 422) {
      return AppErrorCodes.badRequest;
    }

    if (statusCode == 401) {
      return AppErrorCodes.unauthorized;
    }

    if (statusCode == 403) {
      return AppErrorCodes.forbidden;
    }

    if (statusCode == 404) {
      return AppErrorCodes.notFound;
    }

    if (statusCode == 408) {
      return AppErrorCodes.requestTimeout;
    }

    if (statusCode == 429) {
      return AppErrorCodes.tooManyRequests;
    }

    if (statusCode == 503) {
      return AppErrorCodes.serviceUnavailable;
    }

    if (statusCode >= 500 && statusCode <= 599) {
      return AppErrorCodes.server;
    }

    return AppErrorCodes.unknown;
  }
}
