import 'package:flutter/material.dart';

class SettingsViewModel with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _liveCaptionsEnabled = true;
  String _defaultTranslationLanguage = 'en';

  ThemeMode get themeMode => _themeMode;
  bool get liveCaptionsEnabled => _liveCaptionsEnabled;
  String get defaultTranslationLanguage => _defaultTranslationLanguage;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLiveCaptionsEnabled(bool enabled) {
    _liveCaptionsEnabled = enabled;
    notifyListeners();
  }

  void setDefaultTranslationLanguage(String language) {
    _defaultTranslationLanguage = language;
    notifyListeners();
  }

  Future<void> loadSettings() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> saveSettings() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
} 