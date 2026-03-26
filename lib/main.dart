import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ziarat_app/presentation/constants/app_strings.dart';
import 'package:ziarat_app/presentation/localization/app_translations.dart';
import 'package:ziarat_app/presentation/views/maintenence/maintenence_screen.dart';
import 'package:ziarat_app/presentation/views/splash_screen/splash_screen.dart';
import 'application/counter_bloc/counter_bloc.dart';
import 'firebase_options.dart';
import 'infrastructure/services/localization.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  log('✅ Injection Container initialized');

  final savedLocale = await LanguageService.getSavedLanguage();
  log('🌐 Saved locale: $savedLocale');

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(savedLocale: savedLocale),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale? savedLocale;

  const MyApp({super.key, this.savedLocale});

  TextTheme _bumpTextTheme(TextTheme t, double delta) {
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

  String? _getFontForLocale(String? languageCode) {
    switch (languageCode) {
      case 'ur':
        return 'jameel-noori';
      case 'ar':
        return 'noto-sans';
      default:
        return GoogleFonts.raleway().fontFamily; // English
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => CounterBloc())],
      child: GetMaterialApp(
        title: AppStrings.appTitle,
        translations: AppTranslations(),
        locale: savedLocale ?? const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        builder: (context, child) {
          return SafeArea(
            top: false,
            bottom: true,
            child: child ?? const SizedBox.shrink(),
          );
        },
        theme: (() {
          final base = ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            fontFamily: _getFontForLocale(savedLocale?.languageCode),
          );
          final lang = savedLocale?.languageCode ?? 'en';
          if (lang != 'ur') return base;
          // Urdu only: bump all default text sizes.
          return base.copyWith(
            textTheme: _bumpTextTheme(base.textTheme, 6),
            primaryTextTheme: _bumpTextTheme(base.primaryTextTheme, 6),
          );
        })(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}