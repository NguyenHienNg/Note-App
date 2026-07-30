import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeColor {
  system,
  red,
  green,
  blue,
  brown,
  purple,
  yellow,
  orange,
}

class ThemeProvider extends ChangeNotifier {
  static const String themeKey = 'app_theme_mode';
  static const String animationsKey = 'app_enable_animations';
  static const String colorKey = 'app_theme_color';

  ThemeMode _themeMode = ThemeMode.system;
  bool _enableAnimations = true;
  AppThemeColor _themeColor = AppThemeColor.system;

  ThemeProvider() {
    _loadSettings();
  }

  ThemeMode get themeMode => _themeMode;
  bool get enableAnimations => _enableAnimations;
  AppThemeColor get themeColor => _themeColor;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, mode.name);
  }

  void setEnableAnimations(bool enable) async {
    _enableAnimations = enable;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(animationsKey, enable);
  }

  void setThemeColor(AppThemeColor color) async {
    _themeColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(colorKey, color.name);
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeString = prefs.getString(themeKey) ?? 'system';
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => ThemeMode.system,
    );

    _enableAnimations = prefs.getBool(animationsKey) ?? true;

    final colorString = prefs.getString(colorKey) ?? 'system';
    _themeColor = AppThemeColor.values.firstWhere(
      (e) => e.name == colorString,
      orElse: () => AppThemeColor.system,
    );

    notifyListeners();
  }
}