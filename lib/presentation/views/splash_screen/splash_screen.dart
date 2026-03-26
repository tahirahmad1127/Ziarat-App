import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziarat_app/application/navigation_helper.dart';
import 'package:ziarat_app/presentation/views/onBoarding/onBoarding_page.dart';
import 'package:ziarat_app/presentation/views/bottom_bar/bottom_bar.dart';

import '../../../configurations/frontend_config.dart';
import '../../../infrastructure/models/maintenance.dart';
import '../../../infrastructure/services/maintenance.dart';
import '../../constants/asset_constant.dart';
import '../maintenence/maintenence_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _firstLaunchKey = 'is_first_launch';

  final MaintenanceService _maintenanceService = MaintenanceService();

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Minimum splash display time runs in parallel with the Firestore fetch
    final futures = await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      _maintenanceService.getMaintenanceStatus(), // 👈 forces server fetch, bypasses cache
    ]);

    if (!mounted) return;

    final maintenance = futures[1] as MaintenanceModel;

    if (maintenance.isEnabled) {
      // 🔴 App is under maintenance — go to maintenance screen
      NavigatorHelper.pushReplacement(context, const MaintenanceScreen());
      return;
    }

    // ✅ App is healthy — check first-launch and route accordingly
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;

    if (!mounted) return;

    if (isFirstLaunch) {
      await prefs.setBool(_firstLaunchKey, false);
      NavigatorHelper.pushReplacement(context, const OnboardingPage());
    } else {
      NavigatorHelper.pushReplacement(context, const BottomBarScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color
          Container(color: FrontEndConfig.backgroundColor),

          // Background Image
          Positioned.fill(
            child: Image.asset(
              AssetConstant.backgroundimage,
              fit: BoxFit.cover,
            ),
          ),

          // Center Logo
          Center(
            child: Image.asset(
              AssetConstant.splashlogo,
              height: 353,
              width: 353,
            ),
          ),
        ],
      ),
    );
  }
}