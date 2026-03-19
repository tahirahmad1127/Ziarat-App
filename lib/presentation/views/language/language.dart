import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/boarding_button.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import 'package:ziarat_app/presentation/elements/language_tile.dart';
import '../../../infrastructure/services/localization.dart';
import '../../constants/app_strings.dart';
import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  int selectedIndex = -1;

  // Maps index → locale (languageCode, countryCode)
  final List<List<String>> _locales = [
    ['en', 'US'],
    ['ur', 'PK'],
    ['ar', 'SA'],
  ];

  final List<String> engLanguages = [
    AppStrings.languageEnglishTxt,
    AppStrings.languageUrduTxt,
    AppStrings.languageArabicTxt,
  ];

  final List<String> languages = [
    AppStrings.languageEnglishTxt,
    "اُردُو",
    "العربية",
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select whichever language is currently active
    final currentLocale = Get.locale;
    if (currentLocale != null) {
      final idx = _locales.indexWhere((l) => l[0] == currentLocale.languageCode);
      if (idx != -1) selectedIndex = idx;
    }
  }

  Future<void> _onContinue() async {
    if (selectedIndex == -1) {
      Get.back(); // nothing selected, just dismiss
      return;
    }

    final lang = _locales[selectedIndex];
    await LanguageService.updateLanguage(lang[0], lang[1]);
    Get.back(); // go back to Settings, UI will re-render in new language
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),

          Positioned.fill(
            child: Image.asset(
              AssetConstant.backgroundimage,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  0.04.height(context),
                  Text(
                    AppStrings.selectLanguageHeadingTxt.tr,
                    style: FrontEndConfig.languageHeadingTextStyle,
                  ),
                  0.02.height(context),
                  Text(
                    AppStrings.choosePreferredLanguageDescriptionTxt.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                  ),
                  0.04.height(context),

                  Expanded(
                    child: ListView.builder(
                      itemCount: engLanguages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MyContainer(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: FrontEndConfig.btnBorderColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FrontEndConfig.backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: LanguageTile(
                                  title: engLanguages[index].tr,
                                  subtitle: languages[index],
                                  borderGradient: selectedIndex == index
                                      ? FrontEndConfig.listTileBorder
                                      .withOpacity(0.3)
                                      : null,
                                  icon: selectedIndex == index
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  onTap: () {
                                    setState(() => selectedIndex = index);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    child: GradientOutlineButton(
                      borderWidth: 1,
                      onPressed: _onContinue, // <-- wired up
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffA0832C),
                          Color(0xffFAD25B),
                          Color(0xff9B8030),
                        ],
                      ),
                      child: Text(
                        AppStrings.continueBtnText.tr,
                        style: FrontEndConfig.btnTextStyle,
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