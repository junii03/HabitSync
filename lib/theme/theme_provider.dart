import 'package:flutter/material.dart';
import 'package:habbit_tracker/theme/dark_theme.dart';
import 'package:habbit_tracker/theme/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  // initially in light mode
  ThemeData _themeData = lightMode;

  // get current theme
  ThemeData get themeData => _themeData;

  bool get isDark => _themeData == darkMode;

  // set Theme
  set themeData(ThemeData themData) {
    _themeData = themData;
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }

}
