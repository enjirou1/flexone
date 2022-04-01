import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  static const DARK_THEME = 'DARK_THEME';
  static const LANGUAGE = 'LANGUAGE';

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  String _language = 'id';
  String get language => _language;

  PreferencesProvider() {
    _getDarkTheme();
    _getLanguage();
  }

  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  void setDarkTheme(bool value) async {
    final prefs = await _sharedPreferences;
    prefs.setBool(DARK_THEME, value);
    _getDarkTheme();
  }

  void _getDarkTheme() async {
    final prefs = await _sharedPreferences;
    _isDarkTheme = prefs.getBool(DARK_THEME) ?? false;
    notifyListeners();
  }

  void setLanguage(String value) async {
    final prefs = await _sharedPreferences;
    prefs.setString(LANGUAGE, value);
    _getLanguage();
  }

  void _getLanguage() async {
    final prefs = await _sharedPreferences;
    _language = prefs.getString(LANGUAGE) ?? 'id';
    notifyListeners();
  }
}
