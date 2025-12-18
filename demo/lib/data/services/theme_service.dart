// lib/services/theme_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxController {
  static const _key = 'isDarkMode';
  final themeMode = ThemeMode.light.obs;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final isDark = _prefs.getBool(_key) ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      _prefs.setBool(_key, true);
    } else {
      themeMode.value = ThemeMode.light;
      _prefs.setBool(_key, false);
    }
  }
}
