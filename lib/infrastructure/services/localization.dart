import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _countryKey = 'selected_country';

  // Save selected language
  static Future<void> saveLanguage(String languageCode, String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    await prefs.setString(_countryKey, countryCode);
  }

  // Get saved language
  static Future<Locale?> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    final countryCode = prefs.getString(_countryKey);

    if (languageCode != null && countryCode != null) {
      return Locale(languageCode, countryCode);
    }
    return null;
  }

  // Update language, font and save
  static Future<void> updateLanguage(String languageCode, String countryCode) async {
    final locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);

    // Switch font based on language
    Get.changeTheme(ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      fontFamily: _getFontForLocale(languageCode),
      // null for English means Flutter uses its default font
    ));

    await saveLanguage(languageCode, countryCode);
  }

  // Returns null for English (keeps default), custom font for Urdu/Arabic
  static String? _getFontForLocale(String languageCode) {
    switch (languageCode) {
      case 'ur': return 'jameel-noori'; // Jameel Noori Nastaleeq
      case 'ar': return 'noto-sans';    // Noto Sans Arabic
      default:   return null;           // English — no override
    }
  }
}