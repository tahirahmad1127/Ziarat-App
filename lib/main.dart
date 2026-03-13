import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/constants/app_strings.dart';
import 'package:ziarat_app/presentation/localization/app_translations.dart';
import 'package:ziarat_app/presentation/views/splash_screen/splash_screen.dart';

import 'application/counter_bloc/counter_bloc.dart';
import 'infrastructure/services/localiztion.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => CounterBloc())],
      child: GetMaterialApp(
        title: AppStrings.appTitle,
        translations: AppTranslations(),
        locale: savedLocale ?? const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}