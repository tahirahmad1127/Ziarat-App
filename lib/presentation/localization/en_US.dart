import 'package:get/get.dart';

import '../constants/app_strings.dart';

class StringConstantEn extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      /// Core
      AppStrings.appTitle: 'Ziarat App',

      /// General / Common
      AppStrings.settingsTitleTxt: "Settings",
      AppStrings.manageSettingsHeadingTxt: "Manage Settings",
      AppStrings.appFeaturesHeadingTxt: "App Features",
      AppStrings.appOverviewHeadingTxt: "App Overview",
      AppStrings.aboutUsTxt: "About Us",
      AppStrings.rateOurAppTxt: "Rate our App",
      AppStrings.helpAndSupportTxt: "Help & Support",
      AppStrings.couldNotOpenEmailAppTxt: "Could not open email app",
      AppStrings.couldNotOpenWebsiteTxt: "Could not open website",

      /// Bottom navigation / routes (Extra screen)
      AppStrings.extraScreenTitleTxt: "Extra",
      AppStrings.bottomBarTxt: "BottomBar",
      AppStrings.homeScreenTxt: "Home",
      AppStrings.languageScreenTxt: "Language",
      AppStrings.ziyaratScreenTxt: "Ziyarat",
      AppStrings.networkProviderScreenTxt: "Network Provider",
      AppStrings.packageDetailsScreenTxt: "Package Details",
      AppStrings.tasbihCounterScreenTxt: "Tasbih Counter",
      AppStrings.umrahGuideScreenTxt: "Umrah Guide",
      AppStrings.privacyPolicyScreenTxt: "Privacy Policy",
      AppStrings.termsAndConditionsScreenTxt: "Terms and Conditions",
      AppStrings.faqScreenTxt: "FAQ",
      AppStrings.haramGatesScreenTxt: "Haram Gates",

      /// Language screen
      AppStrings.selectLanguageHeadingTxt: "Select Language",
      AppStrings.choosePreferredLanguageDescriptionTxt:
      "Choose your preferred language to continue",
      AppStrings.languageEnglishTxt: "English",
      AppStrings.languageUrduTxt: "Urdu",
      AppStrings.languageArabicTxt: "Arabic",
      AppStrings.continueBtnText: "Continue",

      /// Home screen
      AppStrings.fallbackLocationMakkahSaudiArabiaTxt: "Makkah, Saudi Arabia",
      AppStrings.nextPrayerLabelTxt: "Next Prayer:",
      AppStrings.remainingLabelTxt: "Remaining:",
      AppStrings.ayatOfTheDayTxt: "Ayat of the Day",
      AppStrings.hadithOfTheDayTxt: "Hadith of the Day",
      AppStrings.prayerTimesTxt: "Prayer Times",

      /// Ziarat listing
      AppStrings.ziyaratAppBarTitleTxt: "Ziyarat",
      AppStrings.searchZiyaratHintTxt: "Search Ziyarat...",
      AppStrings.makkahTabTxt: "Makkah",
      AppStrings.madinaTabTxt: "Madina",
      AppStrings.noResultsFoundTxt: "No results found",
      AppStrings.seeMoreSuffixTxt: " See More",

      /// Ziarat details
      AppStrings.noAudioGuideAvailableTxt: "No audio guide available",
      AppStrings.failedToPlayAudioTxt: "Failed to play audio",
      AppStrings.historicalBackgroundHeadingTxt: "Historical Background",
      AppStrings.richTextThePrefixTxt: "The",
      AppStrings.recommendedDuaHeadingTxt: "Recommended Dua",
      AppStrings.closeBtnTxt: "Close",

      /// SIM / Network provider
      AppStrings.networkProvidersAppBarTitleTxt: "Network Providers",
      AppStrings.simInfoHeadingTxt: "SIM Info",
      AppStrings.simInfoDescriptionTxt:
      "Stay connected with families. Most booths are located at King Abdulaziz Airport arrivals.",
      AppStrings.listOfProvidersHeadingTxt: "List of Providers",
      AppStrings.helplineLabelTxt: "Helpline:",
      AppStrings.requirementsForSimHeadingTxt: "Requirements for SIM",
      AppStrings.requirementPassportValidityTxt:
      "1. Original Passport with Visa entry stamp.",
      AppStrings.requirementFingerprintVerificationTxt:
      "2. Fingerprint Verification on Counter.",
      AppStrings.requirementUsuallyActiveTxt:
      "3. Usually active with in 30 minutes.",
      AppStrings.requirementGetSimsJeddahTxt:
      "4. You can get sims easily from Jeddah Airport.",

      /// Package details
      AppStrings.availablePackagesTxt: "Available Packages",
      AppStrings.gbsLabelTxt: "GBs",
      AppStrings.onNetMinutesLabelTxt: "On Net Minutes",
      AppStrings.internationalMinutesLabelTxt: "International Minutes",
      AppStrings.smsLabelTxt: "SMS",

      /// Generic / Error
      AppStrings.genericSomethingWentWrongTxt: "Something went wrong",

      /// Umrah guide
      AppStrings.umrahGuideAppBarTitleTxt: "Umrah Guide",
      AppStrings.prepareBeforeUmrahHeadingTxt:
      "Prepare Before You Perform Umrah",
      AppStrings.checkTravelDocumentsTxt: "Check Travel Documents",
      AppStrings.packSmartlyTxt: "Pack Smartly",
      AppStrings.checkUmrahPackageDetailsTxt:
      "Check Your Umrah Package Details",
      AppStrings.howToPerformUmrahHeadingTxt:
      "How to Perform Umrah - Step by Step Guide",
      AppStrings.methodOfPuttingIhramTxt: "Method of Putting Ihram",
      AppStrings.checkTravelDocumentsTitleTxt: "Check Travel Documents",
      AppStrings.travelDocPassportValidityTxt: "1. Passport Validity",
      AppStrings.travelDocVisaRequirementsTxt: "2. VISA Requirements",
      AppStrings.travelDocFlightDetailsTxt: "3. Flight Details",
      AppStrings.travelDocHotelBookingTxt: "4. Hotel Booking Confirmation",

      /// Onboarding
      AppStrings.onboardingTitle1Txt: "Prepare for Hajj & Umrah",
      AppStrings.onboardingSubtitle1Txt:
      "Essential guides, rituals, and steps to help you perform Hajj & Umrah correctly",
      AppStrings.onboardingTitle2Txt: "Discover Duas & Zeyaraat",
      AppStrings.onboardingSubtitle2Txt:
      "Access powerful duas, Islamic prayers & detailed Zeyaraat guides",
      AppStrings.onboardingTitle3Txt: "Plan visit with our map",
      AppStrings.onboardingSubtitle3Txt:
      "Explore and find the holy sites of Hajj Umrah & other Zeyaraat with our interactive map",
      AppStrings.onboardingGetStartedBtnTxt: "Get Started",
      AppStrings.onboardingNextBtnTxt: "Next",
      AppStrings.onboardingExploreNowBtnTxt: "Explore Now!",
      AppStrings.onboardingSkipTxt: "Skip",

      /// Tasbih Counter
      AppStrings.tasbihAppBarTitleTxt: "Zikar",
      AppStrings.resetCounterTitleTxt: "Reset Counter?",
      AppStrings.resetCounterSubtitleTxt:
      "Are you sure you want to reset the counter? This action cannot be undone.",
      AppStrings.cancelBtnLabelTxt: "Cancel",
      AppStrings.yesResetBtnLabelTxt: "Yes, Reset",
      AppStrings.tasbihAyahArabicTxt:
      "أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ",
      AppStrings.tasbihAyahTranslationTxt:
      "\"Verily, in the remembrance of Allah do hearts find rest.\"",

      /// Haram Gates
      AppStrings.haramGatesAppBarTitleTxt: "Haram Gates",
      AppStrings.haramGatesInfoHeadingTxt: "Haram Gates Information",
      AppStrings.haramGateKingFahadEnTxt: "King Fahad Gate",
      AppStrings.haramGateKingFahadArTxt: "باب الملك فهد",
      AppStrings.haramGateKingFahadDescTxt:
      "Gate 79: Large eastern entrance with, often used for direct, convenient access to the Mataf.",
      AppStrings.haramGateKingAbdulAzizEnTxt: "King Abdul Aziz Gate",
      AppStrings.haramGateKingAbdulAzizArTxt: "باب الملك عبدالعزيز",
      AppStrings.haramGateKingAbdulAzizDescTxt:
      "Gate 1: One of the main entrances to Masjid al-Haram, located on the northern side.",
      AppStrings.haramGateBabAlSalamEnTxt: "Bab Al Salam",
      AppStrings.haramGateBabAlSalamArTxt: "باب السلام",
      AppStrings.haramGateBabAlSalamDescTxt:
      "Gate 2: The Gate of Peace, a historic entrance used by pilgrims for centuries.",
      AppStrings.haramGateBabAlUmrahEnTxt: "Bab Al Umrah",
      AppStrings.haramGateBabAlUmrahArTxt: "باب العمرة",
      AppStrings.haramGateBabAlUmrahDescTxt:
      "Gate 3: Commonly used by pilgrims performing Umrah to enter Masjid al-Haram.",
      AppStrings.haramGateBabIbrahimEnTxt: "Bab Ibrahim",
      AppStrings.haramGateBabIbrahimArTxt: "باب إبراهيم",
      AppStrings.haramGateBabIbrahimDescTxt:
      "Gate 4: Named after Prophet Ibrahim, located on the western side of the mosque.",
      AppStrings.closeBottomSheetBtnTxt: "Close",
      AppStrings.exitAppTitleTxt: "Exit App?",
      AppStrings.exitAppSubtitleTxt:
      "Do you want to exit the app or stay on this screen?",
      AppStrings.stayBtnLabelTxt: "Stay",
      AppStrings.exitBtnLabelTxt: "Exit",

      /// FAQ Screen
      AppStrings.faqAppBarTitleTxt: "Umrah Questions",
      AppStrings.faqIntroTxt:
      "Some frequently asked questions (FAQs) about Umrah that people commonly ask before planning their journey:",
      AppStrings.faqQ1Txt: "Can Umrah be performed anytime?",
      AppStrings.faqA1Txt:
      "Yes, Umrah can be performed any time of the year, except during specific days of Hajj when pilgrims focus on Hajj rituals.",
      AppStrings.faqQ2Txt: "What is the difference between Hajj and Umrah?",
      AppStrings.faqA2Txt:
      "Hajj is obligatory once in a lifetime for able Muslims and performed on specific dates. Umrah is voluntary and can be performed anytime.",
      AppStrings.faqQ3Txt: "What should I wear for Umrah?",
      AppStrings.faqA3Txt:
      "Men wear two white unstitched cloths called Ihram. Women wear modest, loose-fitting clothing that covers the entire body except face and hands.",
      AppStrings.faqQ4Txt: "How long does Umrah take?",
      AppStrings.faqA4Txt:
      "Umrah typically takes 2 to 5 hours to complete, depending on crowd levels and your pace.",

      /// Method of Putting Ihram detail
      AppStrings.methodOfPuttingIhramDescriptionTxt:
      "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage.",

    },
  };
}