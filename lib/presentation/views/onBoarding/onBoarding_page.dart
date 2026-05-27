import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ziarat_app/infrastructure/models/onboarding.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/views/bottom_bar/bottom_bar.dart';
import 'package:ziarat_app/presentation/views/extra/extra.dart';

import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../elements/boarding_button.dart';
import '../../constants/app_strings.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller = PageController();
  int currentIndex = 0;

  List<OnBoarding> onBoardingList = [
    OnBoarding(
      image: AssetConstant.onBoarding1,
      title: AppStrings.onboardingTitle1Txt,
      subtitle: AppStrings.onboardingSubtitle1Txt,
    ),
    OnBoarding(
      image: AssetConstant.onBoarding2,
      title: AppStrings.onboardingTitle2Txt,
      subtitle: AppStrings.onboardingSubtitle2Txt,
    ),
    OnBoarding(
      image: AssetConstant.onBoarding3,
      title: AppStrings.onboardingTitle3Txt,
      subtitle: AppStrings.onboardingSubtitle3Txt,
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Explicit font for onboarding independent of theme,
  /// using correct family names from pubspec.
  String _onboardingFontFamily() {
    final lang = Get.locale?.languageCode ?? 'en';
    switch (lang) {
      case 'ur':
        return 'jameel-noori';
      case 'ar':
        return 'noto-sans';
      default:
      // ✅ fixed: use GoogleFonts directly, same as FrontEndConfig._currentFont()
        return GoogleFonts.raleway().fontFamily!;
    }
  }

  String getMainButtonText() {
    if (currentIndex == 0) return AppStrings.onboardingGetStartedBtnTxt.tr;
    if (currentIndex == 1) return AppStrings.onboardingNextBtnTxt.tr;
    return AppStrings.onboardingExploreNowBtnTxt.tr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// Background
          Container(color: FrontEndConfig.backgroundColor),

          Positioned.fill(
            child: Image.asset(
              AssetConstant.backgroundimage,
              fit: BoxFit.cover,
            ),
          ),

          /// Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          /// Main Content
          Column(
            children: [

              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: onBoardingList.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Expanded(
                          flex: 5,
                          child: Image.asset(
                            onBoardingList[index].image.toString(),
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),

                        0.03.height(context),

                        SmoothPageIndicator(
                          controller: controller,
                          count: onBoardingList.length,
                          effect: const ExpandingDotsEffect(
                            dotColor: Color(0xffFFFFFF),
                            activeDotColor: Color(0xffC89C18),
                            dotHeight: 9,
                            dotWidth: 9,
                          ),
                        ),

                        0.03.height(context),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            onBoardingList[index].title.tr,
                            textAlign: TextAlign.center,
                            style: FrontEndConfig.languageHeadingTextStyle
                                .copyWith(
                              fontSize: FrontEndConfig.fontSize(28),
                              fontFamily: _onboardingFontFamily(),
                            ),
                          ),
                        ),

                        0.02.height(context),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            onBoardingList[index].subtitle.tr,
                            textAlign: TextAlign.center,
                            style: FrontEndConfig.bodyTextStyle.copyWith(
                              fontSize: FrontEndConfig.fontSize(15),
                              fontWeight: FontWeight.w400,
                              fontFamily: _onboardingFontFamily(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// Bottom Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Row(
                  children: [

                    /// Back Button
                    if (currentIndex != 0)
                      GradientOutlineButton(
                        width: 56,
                        height: 56,
                        borderRadius: 30,
                        borderWidth: 2,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffA0832C),
                            Color(0xffFAD25B),
                            Color(0xff9B8030),
                          ],
                        ),
                        onPressed: () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),

                    0.03.width(context),

                    Expanded(
                      child: GradientOutlineButton(
                        height: 56,
                        borderRadius: 30,
                        borderWidth: 2,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffA0832C),
                            Color(0xffFAD25B),
                            Color(0xff9B8030),
                          ],
                        ),
                        onPressed: () {
                          if (currentIndex == onBoardingList.length - 1) {
                            NavigatorHelper.pushReplacement(
                                context, const BottomBarScreen());
                          } else {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          getMainButtonText(),
                          style: FrontEndConfig.btnTextStyle.copyWith(
                            fontSize: FrontEndConfig.fontSize(16),
                            fontFamily: _onboardingFontFamily(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}