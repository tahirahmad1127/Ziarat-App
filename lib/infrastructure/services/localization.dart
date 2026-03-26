import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _countryKey = 'selected_country';

  static TextTheme _bumpTextTheme(TextTheme t, double delta) {
    TextStyle? bump(TextStyle? s) {
      if (s == null) return null;
      if (s.fontSize == null) return s;
      return s.copyWith(fontSize: s.fontSize! + delta);
    }
    return t.copyWith(
      displayLarge: bump(t.displayLarge),
      displayMedium: bump(t.displayMedium),
      displaySmall: bump(t.displaySmall),
      headlineLarge: bump(t.headlineLarge),
      headlineMedium: bump(t.headlineMedium),
      headlineSmall: bump(t.headlineSmall),
      titleLarge: bump(t.titleLarge),
      titleMedium: bump(t.titleMedium),
      titleSmall: bump(t.titleSmall),
      bodyLarge: bump(t.bodyLarge),
      bodyMedium: bump(t.bodyMedium),
      bodySmall: bump(t.bodySmall),
      labelLarge: bump(t.labelLarge),
      labelMedium: bump(t.labelMedium),
      labelSmall: bump(t.labelSmall),
    );
  }

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
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      fontFamily: _getFontForLocale(languageCode),
      // null for English means Flutter uses its default font
    );
    Get.changeTheme(
      languageCode == 'ur'
          ? base.copyWith(
              textTheme: _bumpTextTheme(base.textTheme, 6),
              primaryTextTheme: _bumpTextTheme(base.primaryTextTheme, 6),
            )
          : base,
    );

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