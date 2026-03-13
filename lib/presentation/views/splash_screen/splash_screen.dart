import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ziarat_app/application/navigation_helper.dart';
import 'package:ziarat_app/presentation/views/onBoarding/onBoarding_page.dart';

import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    Timer(const Duration(seconds: 3), () async {
      NavigatorHelper.pushReplacement(context, const OnboardingPage());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Background Color
          Container(color: FrontEndConfig.backgroundColor,),
          //Background Image
          Positioned.fill(
            child: Image.asset(
              AssetConstant.backgroundimage,
              fit: BoxFit.cover,
            ),
          ),

          ///Center Logo
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
