class ApiConstants {
  static const String authority = 'story-api.dicoding.dev';
  static const String basePath = '/v1';

  static Uri buildUri(String path, {Map<String, String>? queryParameters}) {
    return Uri.https(authority, '$basePath$path', queryParameters);
  }
}
