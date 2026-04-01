import 'package:flutter/material.dart';

import '../../core/storage/app_settings_storage.dart';

class LocaleViewModel extends ChangeNotifier {
  LocaleViewModel({required AppSettingsStorage settingsStorage})
    : _settingsStorage = settingsStorage;

  final AppSettingsStorage _settingsStorage;

  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> restoreLocale() async {
    final String? code = _settingsStorage.localeCode;
    if (code == null || code.isEmpty) {
      return;
    }

    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale?.languageCode == locale.languageCode) {
      return;
    }

    _locale = locale;
    notifyListeners();
    await _settingsStorage.saveLocaleCode(locale.languageCode);
  }
}
