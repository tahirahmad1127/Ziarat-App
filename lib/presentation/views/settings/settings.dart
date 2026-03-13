import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/listTile.dart';
import 'package:ziarat_app/presentation/views/privacy_policy/layout/body.dart';
import '../../../application/navigation_helper.dart';
import '../../constants/asset_constant.dart';
import '../faqs_screen/FAQ_Screen.dart';
import '../haram_gates/Haram_Gates.dart';
import '../language/language.dart';
import '../sim/layout/body.dart';
import '../term_conditions/layout/body.dart';
import '../../constants/app_strings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'ali@gmail.com',
      queryParameters: {
        'subject': 'About Us - Ziarat App',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.couldNotOpenEmailAppTxt.tr)),
        );
      }
    }
  }

  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://www.example.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.couldNotOpenWebsiteTxt.tr)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Color
          Container(color: FrontEndConfig.backgroundColor),

          /// Background Image
          Positioned.fill(
            child: Image.asset(
              AssetConstant.backgroundimage,
              fit: BoxFit.cover,
            ),
          ),

          /// Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// AppBar (fixed, not scrollable)
                  CommonAppBar(
                    title: AppStrings.settingsTitleTxt.tr,
                    color: FrontEndConfig.iconColor,
                  ),

                  0.02.height(context),

                  /// Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Heading
                          Text(AppStrings.manageSettingsHeadingTxt.tr, style: FrontEndConfig.mainTextStyle),

                          0.02.height(context),

                          /// Language
                          CommonListTile(
                            height: 56,
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.languageIcon,
                            trailing: Container(
                              decoration: BoxDecoration(
                                gradient: FrontEndConfig.btnBorderColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 90,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      NavigatorHelper.push(
                                        context,
                                        const Language(),
                                      );
                                    },
                                    // In SettingsPage, replace the hardcoded label:
                                    child: Text(
                                      Get.locale?.languageCode == 'ar'
                                          ? 'العربية'
                                          : Get.locale?.languageCode == 'ur'
                                          ? 'اُردُو'
                                          : AppStrings.languageEnglishTxt.tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Raleway',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: AppStrings.languageScreenTxt.tr,
                            onTap: () {
                              NavigatorHelper.push(
                                context,
                                const Language(),
                              );
                            },
                          ),

                          0.02.height(context),

                          /// Help & Support
                          CommonListTile(
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.helpIcon,
                            title: AppStrings.helpAndSupportTxt.tr,
                            onTap: _launchEmail,
                          ),

                          0.02.height(context),

                          /// Heading
                          Text(AppStrings.appFeaturesHeadingTxt.tr, style: FrontEndConfig.mainTextStyle),

                          0.02.height(context),

                          /// Network Provider
                          CommonListTile(
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.privacyIcon,
                            title: AppStrings.networkProviderScreenTxt.tr,
                            onTap: () {
                              NavigatorHelper.push(
                                context,
                                const SimProviderViewBody(),
                              );
                            },
                          ),

                          0.02.height(context),

                          /// Umrah Masail
                          CommonListTile(
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.privacyIcon,
                            title: AppStrings.umrahMasailScreenTxt.tr,
                            onTap: () {
                              NavigatorHelper.push(
                                context,
                                 FaqScreen(),
                              );
                            },
                          ),

                          0.02.height(context),

                          /// Haram Gates
                          CommonListTile(
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.privacyIcon,
                            title: AppStrings.haramGatesScreenTxt.tr,
                            onTap: () {
                              NavigatorHelper.push(
                                context,
                                 HaramGatesScreen(),
                              );
                            },
                          ),

                          0.02.height(context),

                          /// Heading
                          Text(AppStrings.appOverviewHeadingTxt.tr, style: FrontEndConfig.mainTextStyle),

                          0.02.height(context),

                          /// Privacy Policy
                          CommonListTile(
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.privacyIcon,
                            title: AppStrings.privacyPolicyScreenTxt.tr,
                            onTap: () {
                              NavigatorHelper.push(
                                context,
                                const PrivacyPolicyViewBody(),
                              );
                            },
                          ),

                          0.02.height(context),

                          /// Terms & Conditions
                          CommonListTile(
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.privacyIcon,
                            title: AppStrings.termsAndConditionsScreenTxt.tr,
                            onTap: () {
                              NavigatorHelper.push(
                                context,
                                const TermsConditionsViewBody(),
                              );
                            },
                          ),

                          0.02.height(context),

                          /// About Us → opens website
                          CommonListTile(
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.helpIcon,
                            title: AppStrings.aboutUsTxt.tr,
                            onTap: _launchWebsite,
                          ),

                          0.02.height(context),

                          /// Rate our App
                          CommonListTile(
                            tileColor: FrontEndConfig.listTileColor,
                            borderGradient: FrontEndConfig.listTileBorder,
                            image: AssetConstant.rateAppIcon,
                            title: AppStrings.rateOurAppTxt.tr,
                            onTap: () {},
                          ),

                          0.02.height(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}