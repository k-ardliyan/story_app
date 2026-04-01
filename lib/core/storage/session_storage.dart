import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  SessionStorage(this._preferences);

  final SharedPreferences _preferences;

  static const String _tokenKey = 'session_token';
  static const String _userIdKey = 'session_user_id';
  static const String _nameKey = 'session_name';

  String? get token => _preferences.getString(_tokenKey);
  String? get userId => _preferences.getString(_userIdKey);
  String? get name => _preferences.getString(_nameKey);

  Future<void> saveSession({
    required String token,
    required String userId,
    required String name,
  }) async {
    await _preferences.setString(_tokenKey, token);
    await _preferences.setString(_userIdKey, userId);
    await _preferences.setString(_nameKey, name);
  }

  Future<void> clearSession() async {
    await _preferences.remove(_tokenKey);
    await _preferences.remove(_userIdKey);
    await _preferences.remove(_nameKey);
  }
}
