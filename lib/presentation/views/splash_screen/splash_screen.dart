import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziarat_app/application/navigation_helper.dart';
import 'package:ziarat_app/presentation/views/onBoarding/onBoarding_page.dart';
import 'package:ziarat_app/presentation/views/bottom_bar/bottom_bar.dart';

import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';

// ✅ This is the entry point — check first launch and route accordingly
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _firstLaunchKey = 'is_first_launch';

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;

    if (isFirstLaunch) {
      // ✅ First time — show splash for 3 seconds, then go to onboarding
      await prefs.setBool(_firstLaunchKey, false);
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        NavigatorHelper.pushReplacement(context, const OnboardingPage());
      }
    } else {
      // ✅ Already installed — still show splash, then go directly to the app
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        NavigatorHelper.pushReplacement(context, const BottomBarScreen());
      }
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