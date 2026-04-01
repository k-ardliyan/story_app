class ApiConstants {
  static const authority = 'story-api.dicoding.dev';
  static const basePath = '/v1';

  static Uri buildUri(String path, {Map<String, String>? queryParameters}) {
    return Uri.https(authority, '$basePath$path', queryParameters);
  }
}
