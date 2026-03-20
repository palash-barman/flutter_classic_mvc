import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_classic_mvc/services/storage_service.dart';

class ThemeController extends GetxController {
  final _storage = StorageService();
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _isDarkMode.value = _storage.getThemeMode();
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _storage.saveThemeMode(_isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }
}
