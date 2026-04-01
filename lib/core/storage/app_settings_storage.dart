import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsStorage {
  AppSettingsStorage(this._preferences);

  final SharedPreferences _preferences;

  static const String _localeCodeKey = 'app_locale_code';

  String? get localeCode => _preferences.getString(_localeCodeKey);

  Future<void> saveLocaleCode(String localeCode) {
    return _preferences.setString(_localeCodeKey, localeCode);
  }
}
