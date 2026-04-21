import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeController extends ChangeNotifier {
  static const String _storageKey = 'selected_theme_mode';

  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoaded = false;

  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _isLoaded;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_storageKey);

    _themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final nextMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    if (_themeMode == nextMode) {
      return;
    }

    _themeMode = nextMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }
}

final appThemeController = AppThemeController();
