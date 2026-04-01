abstract final class AppErrorCodes {
  static const String noInternet = 'no_internet';
  static const String requestTimeout = 'request_timeout';
  static const String sessionExpired = 'session_expired';
  static const String unauthorized = 'unauthorized';
  static const String forbidden = 'forbidden';
  static const String notFound = 'not_found';
  static const String tooManyRequests = 'too_many_requests';
  static const String server = 'server_error';
  static const String badRequest = 'bad_request';
  static const String serviceUnavailable = 'service_unavailable';
  static const String unknown = 'unknown_error';

  static const Set<String> all = <String>{
    noInternet,
    requestTimeout,
    sessionExpired,
    unauthorized,
    forbidden,
    notFound,
    tooManyRequests,
    server,
    badRequest,
    serviceUnavailable,
    unknown,
  };
}
