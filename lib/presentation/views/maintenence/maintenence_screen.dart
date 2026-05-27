import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/constants/asset_constant.dart';
import '../../../configurations/frontend_config.dart';
import '../../constants/app_strings.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    // Floating animation for the maintenance image
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // Fade-in animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = Get.locale?.languageCode ?? 'en';
    final isRtl = langCode == 'ar' || langCode == 'ur';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Container(
              color: FrontEndConfig.backgroundColor,
            ),
            Positioned.fill(
              child: Image.asset(
                AssetConstant.backgroundimage,
                fit: BoxFit.cover,
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Top spacing
                  const SizedBox(height: 30),

                  // Center content - takes up most of the space
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Maintenance image with floating animation
                            AnimatedBuilder(
                              animation: _floatingController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    0,
                                    _floatingController.value * 15 - 7.5,
                                  ),
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                AssetConstant.underMaintenence,
                                height: 280,
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 60),

                            // Main text content
                            FadeTransition(
                              opacity: _fadeController,
                              child: Column(
                                children: [
                                  Text(
                                    AppStrings.maintenanceTitleTxt.tr,
                                    textAlign: TextAlign.center,
                                    style: FrontEndConfig.subHeadingTextStyle
                                        .copyWith(
                                      fontSize: FrontEndConfig.fontSize(24),
                                      height: 1.7,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withOpacity(0.85),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    AppStrings.maintenanceDescriptionTxt.tr,
                                    textAlign: TextAlign.center,
                                    style: FrontEndConfig.subHeadingTextStyle
                                        .copyWith(
                                      fontSize: FrontEndConfig.fontSize(16),
                                      height: 1.7,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.85),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom logo and name section
                  FadeTransition(
                    opacity: _fadeController,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 32,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),

                          // Logo
                          Image.asset(
                            AssetConstant.splashlogo,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ziyarat-e-Haramain',
                            style: FrontEndConfig.languageHeadingTextStyle
                                .copyWith(
                              fontSize: FrontEndConfig.fontSize(18),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}