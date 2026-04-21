import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeController extends ChangeNotifier {
  static const String _storageKey = 'selected_theme_mode';

  bool _isDarkMode = false;
  bool _isLoaded = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_storageKey);

    _isDarkMode = savedMode == 'dark';
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    if (_isDarkMode == isDarkMode) {
      return;
    }

    _isDarkMode = isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }
}

final appThemeController = AppThemeController();
