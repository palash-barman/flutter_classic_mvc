import 'dart:ui';

import 'package:get/get.dart';

import 'package:demo_project/services/storage_service.dart';

class LanguageInfo {
  final String code;
  final String country;
  final String name;
  final String nativeName;

  LanguageInfo({
    required this.code,
    required this.country,
    required this.name,
    required this.nativeName,
  });

  String get localeString => '${code}_$country';
}

class LocalizationController extends GetxController {
  final _storage = StorageService();
  final _locale = const Locale('en', 'US').obs;

  // List of all available languages
  static final List<LanguageInfo> availableLanguages = [
    LanguageInfo(code: 'en', country: 'US', name: 'English', nativeName: 'English'),
    LanguageInfo(code: 'ar', country: 'SA', name: 'Arabic', nativeName: 'العربية'),
    LanguageInfo(code: 'es', country: 'ES', name: 'Spanish', nativeName: 'Español'),
    LanguageInfo(code: 'fr', country: 'FR', name: 'French', nativeName: 'Français'),
  ];

  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    final saved = _storage.getLanguageCode();
    if (saved != null && saved.contains('_')) {
      final parts = saved.split('_');
      _locale.value = Locale(parts[0], parts[1]);
    }
  }

  void changeLocale(String languageCode, String countryCode) {
    final newLocale = Locale(languageCode, countryCode);
    _locale.value = newLocale;
    Get.updateLocale(newLocale);
    _storage.saveLanguageCode('${languageCode}_$countryCode');
  }

  void changeLanguage(LanguageInfo language) {
    changeLocale(language.code, language.country);
  }

  void toggleLocale() {
    if (_locale.value.languageCode == 'en') {
      changeLocale('ar', 'SA');
    } else {
      changeLocale('en', 'US');
    }
  }

  String getCurrentLanguageName() {
    final current = availableLanguages.firstWhere(
      (lang) => lang.code == _locale.value.languageCode && lang.country == _locale.value.countryCode,
      orElse: () => availableLanguages[0],
    );
    return current.name;
  }
}
