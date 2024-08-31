import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode =>
      _themeMode == ThemeMode.dark ||
      (_themeMode == ThemeMode.system &&
          PlatformDispatcher.instance.platformBrightness == Brightness.dark);

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
