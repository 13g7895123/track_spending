import 'package:flutter/material.dart';
import '../../data/services/local_storage_service.dart';

class ThemeProvider with ChangeNotifier {
  final LocalStorageService _localStorageService;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(this._localStorageService) {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    return _themeMode == ThemeMode.dark;
  }

  bool get isLightMode {
    return _themeMode == ThemeMode.light;
  }

  bool get isSystemMode {
    return _themeMode == ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final savedTheme = _localStorageService.getThemeMode();
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
          break;
      }
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();

      String themeName;
      switch (themeMode) {
        case ThemeMode.light:
          themeName = 'light';
          break;
        case ThemeMode.dark:
          themeName = 'dark';
          break;
        case ThemeMode.system:
        default:
          themeName = 'system';
          break;
      }

      await _localStorageService.saveThemeMode(themeName);
    }
  }

  Future<void> toggleTheme() async {
    switch (_themeMode) {
      case ThemeMode.light:
        await setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        await setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
      default:
        await setThemeMode(ThemeMode.light);
        break;
    }
  }
}