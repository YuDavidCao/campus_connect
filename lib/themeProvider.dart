import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(bool onDarkMode) {
    themeMode = onDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
