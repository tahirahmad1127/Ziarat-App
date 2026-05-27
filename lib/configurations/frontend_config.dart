import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class FrontEndConfig {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  // Base design width
  static const double _baseWidth = 375;

  static double responsiveFont(double size) {
    return screenWidth * (size / _baseWidth);
  }

  // ── Colors ─────────────────────────────────────────────────────────────────
  static Color backgroundColor = const Color(0xff243243);
  static LinearGradient btnBorderColor = const LinearGradient(colors: [
    Color(0xffA0832C),
    Color(0xffFAD25B),
    Color(0xff9B8030),
  ]);
  static Color btnTextColor = const Color(0xffFFFFFF);
  static Color iconColor = const Color(0xffFFFFFF);
  static Color appBarTitleColor = const Color(0xffFFFFFF);
  static Color textColor = const Color(0xffFFFFFF);
  static LinearGradient tasbihColor = const LinearGradient(colors: [
    Color(0xffC89C18),
    Color(0xffE9C41E),
  ]);
  static Color listTileColor = const Color(0xff354A64);
  static LinearGradient listTileBorder = const LinearGradient(colors: [
    Color(0xffA0832C),
    Color(0xffFAD25B),
    Color(0xff9B8030),
  ]);
  static Color listTileTextColor = const Color(0xffFFFFFF);
  static Color listTileIconColor = const Color(0xffFFFFFF);
  static Color arabicTextColor = const Color(0xffA2A2A2);
  static Color arabicAyatTextColor = const Color(0xffFFFFFF);
  static Color subHeadingTextColor = const Color(0xffC1C1C1);

  // ── Dynamic Font Helper ────────────────────────────────────────────────────
  /// Called at runtime on every text style access.
  /// Always reflects the current locale — works after live language switch too.
  static String? _currentFont() {
    final lang = Get.locale?.languageCode ?? 'en';
    switch (lang) {
      case 'ur':
        return 'jameel-noori';
      case 'ar':
        return 'noto-sans';
      default:
        return GoogleFonts.raleway().fontFamily; // English
    }
  }

  /// Arabic/Quran text is always noto-sans regardless of app locale
  static String get _arabicFont => 'noto-sans';

  /// English and Arabic keep their original sizes.
  static double _fontSizeForCurrentLocale(double baseSize) {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ur') return baseSize +6;
    if (lang == 'en') return baseSize;
    if (lang == 'ar') return baseSize +2;
    return baseSize;
  }

  /// Use this when a widget sets fontSize manually (copyWith / TextStyle).
  static double fontSize(double baseSize) => _fontSizeForCurrentLocale(baseSize);

  // ── Text Styles ────────────────────────────────────────────────────────────
  // All styles are GETTERS (not fields) so _currentFont() is called
  // fresh every time — ensuring correct font after language switch.

  /// Button Text Style
  static TextStyle get btnTextStyle => TextStyle(
    fontSize: _fontSizeForCurrentLocale(20),
    fontWeight: FontWeight.w500,
    color: btnTextColor,
    fontFamily: _currentFont(),
  );

  /// Body Text Style
  static TextStyle get bodyTextStyle => TextStyle(
    fontSize: _fontSizeForCurrentLocale(14),
    fontWeight: FontWeight.w400,
    color: textColor,
    fontFamily: _currentFont(),
  );

  /// Sub Heading Text Style
  static TextStyle get subHeadingTextStyle => TextStyle(
    fontSize: _fontSizeForCurrentLocale(12),
    fontWeight: FontWeight.w400,
    color: subHeadingTextColor,
    fontFamily: _currentFont(),
  );

  /// Heading Text Style
  static TextStyle get headingTextStyle => TextStyle(
    fontSize: _fontSizeForCurrentLocale(14),
    fontWeight: FontWeight.w700,
    color: textColor,
    fontFamily: _currentFont(),
  );

  /// Arabic Text Style — always noto-sans regardless of app locale
  static TextStyle get arabicTextStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: arabicTextColor,
    fontFamily: _arabicFont,
  );

  /// Arabic Ayat Text Style — always noto-sans regardless of app locale
  static TextStyle get arabicAyatTextStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: arabicAyatTextColor,
    fontFamily: _arabicFont,
  );

  /// Main Text Style
  static TextStyle get mainTextStyle => TextStyle(
    fontSize: _fontSizeForCurrentLocale(20),
    fontWeight: FontWeight.w600,
    color: textColor,
    fontFamily: _currentFont(),
  );

  /// Language Heading Style
  static TextStyle get languageHeadingTextStyle => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: _fontSizeForCurrentLocale(24),
    color: textColor,
    fontFamily: _currentFont(),
  );

  /// TabBar Text Style
  static TextStyle get tabBarTextStyle => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: _fontSizeForCurrentLocale(18),
    color: textColor,
    fontFamily: _currentFont(),
  );

  /// Package Details Text Style
  static TextStyle get packageDetailTextStyle => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: _fontSizeForCurrentLocale(9),
    color: textColor,
    fontFamily: _currentFont(),
  );

  /// Package Text Style
  static TextStyle get packageTextStyle => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: _fontSizeForCurrentLocale(12),
    color: textColor,
    fontFamily: _currentFont(),
  );
}