import 'package:get/get_navigation/src/root/internacionalization.dart';

import '../constants/app_strings.dart';

class StringConstantUr extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ur_PK': {
      // For now, Urdu values mostly mirror English with some Urdu where already present.

      /// Core
      AppStrings.appTitle: 'زیارت ایپ',

      /// General / Common
      AppStrings.umrahMasailScreenTxt: "عمرہ مسائل",
      AppStrings.settingsTitleTxt: "سیٹنگز",
      AppStrings.manageSettingsHeadingTxt: "سیٹنگز مینیج کریں",
      AppStrings.appFeaturesHeadingTxt: "ایپ فیچرز",
      AppStrings.appOverviewHeadingTxt: "ایپ کا تعارف",
      AppStrings.aboutUsTxt: "ہمارے بارے میں",
      AppStrings.rateOurAppTxt: "ایپ کو ریٹ کریں",
      AppStrings.helpAndSupportTxt: "مدد اور سپورٹ",
      AppStrings.couldNotOpenEmailAppTxt:
      "ای میل ایپ اوپن نہیں ہو سکی",
      AppStrings.couldNotOpenWebsiteTxt:
      "ویب سائٹ اوپن نہیں ہو سکی",

      /// Bottom navigation / routes (Extra screen)
      AppStrings.extraScreenTitleTxt: "اضافی",
      AppStrings.bottomBarTxt: "بوٹم بار",
      AppStrings.homeScreenTxt: "ہوم",
      AppStrings.languageScreenTxt: "زبان",
      AppStrings.ziyaratScreenTxt: "زیارات",
      AppStrings.networkProviderScreenTxt: "نیٹ ورک پرووائیڈر",
      AppStrings.packageDetailsScreenTxt: "پیکج کی تفصیلات",
      AppStrings.tasbihCounterScreenTxt: "تسبیح کاؤنٹر",
      AppStrings.umrahGuideScreenTxt: "عمرہ گائیڈ",
      AppStrings.privacyPolicyScreenTxt: "پرائیویسی پالیسی",
      AppStrings.termsAndConditionsScreenTxt: "شرائط و ضوابط",
      AppStrings.faqScreenTxt: "سوالات",
      AppStrings.haramGatesScreenTxt: "حرم گیٹس",

      /// Language screen
      AppStrings.selectLanguageHeadingTxt: "زبان منتخب کریں",
      AppStrings.choosePreferredLanguageDescriptionTxt:
      "جاری رکھنے کے لیے اپنی پسندیدہ زبان منتخب کریں",
      AppStrings.languageEnglishTxt: "انگلش",
      AppStrings.languageUrduTxt: "اردو",
      AppStrings.languageArabicTxt: "عربی",
      AppStrings.continueBtnText: "جاری رکھیں",

      /// Home screen
      AppStrings.fallbackLocationMakkahSaudiArabiaTxt: "مکہ، سعودیہ",
      AppStrings.nextPrayerLabelTxt: "اگلی نماز:",
      AppStrings.remainingLabelTxt: "باقی وقت:",
      AppStrings.ayatOfTheDayTxt: "آج کی آیت",
      AppStrings.hadithOfTheDayTxt: "آج کی حدیث",
      AppStrings.prayerTimesTxt: "نمازوں کے اوقات",

      /// Ziarat listing
      AppStrings.ziyaratAppBarTitleTxt: "زیارات",
      AppStrings.searchZiyaratHintTxt: "زیارت تلاش کریں...",
      AppStrings.searchHintTxt: "تلاش کریں...",
      AppStrings.makkahTabTxt: "مکہ",
      AppStrings.madinaTabTxt: "مدینہ",
      AppStrings.noResultsFoundTxt: "کوئی نتیجہ نہیں ملا",
      AppStrings.seeMoreSuffixTxt: " مزید دیکھیں",

      /// Ziarat details
      AppStrings.noAudioGuideAvailableTxt:
      "آڈیو گائیڈ دستیاب نہیں",
      AppStrings.failedToPlayAudioTxt: "آڈیو چلنے میں ناکامی",
      AppStrings.historicalBackgroundHeadingTxt: "تاریخی پس منظر",
      AppStrings.richTextThePrefixTxt: "The",
      AppStrings.recommendedDuaHeadingTxt: "مسنون دعا",
      AppStrings.closeBtnTxt: "بند کریں",

      /// SIM / Network provider
      AppStrings.networkProvidersAppBarTitleTxt: "نیٹ ورک پرووائیڈر",
      AppStrings.simInfoHeadingTxt: "سم کی معلومات",
      AppStrings.simInfoDescriptionTxt:
      "خاندان سے رابطے میں رہیں۔ زیادہ تر بوتھ کنگ عبدالعزیز ایئرپورٹ آمد پر موجود ہیں۔",
      AppStrings.listOfProvidersHeadingTxt: "پرووائیڈرز کی فہرست",
      AppStrings.helplineLabelTxt: "ہیلپ لائن:",
      AppStrings.requirementsForSimHeadingTxt: "سم کے تقاضے",
      AppStrings.requirementPassportValidityTxt:
      "1. داخلہ اسٹیمپ کے ساتھ اصلی پاسپورٹ۔",
      AppStrings.requirementFingerprintVerificationTxt:
      "2. کاؤنٹر پر فنگر پرنٹ ویریفکیشن۔",
      AppStrings.requirementUsuallyActiveTxt:
      "3. عام طور پر 30 منٹ میں فعال ہو جاتی ہے۔",
      AppStrings.requirementGetSimsJeddahTxt:
      "4. آپ جدہ ایئرپورٹ سے آسانی سے سم حاصل کر سکتے ہیں۔",

      /// Package details
      AppStrings.availablePackagesTxt: "دستیاب پیکجز",
      AppStrings.gbsLabelTxt: "جی بی",
      AppStrings.onNetMinutesLabelTxt: "آن نیٹ منٹ",
      AppStrings.internationalMinutesLabelTxt: "انٹرنیشنل منٹ",
      AppStrings.smsLabelTxt: "ایس ایم ایس",

      /// Generic / Error
      AppStrings.genericSomethingWentWrongTxt: "کچھ غلط ہو گیا",

      /// Umrah guide
      AppStrings.guideAppBarTitleTxt: "گائیڈ",
      AppStrings.umrahGuideAppBarTitleTxt: "عمرہ گائیڈ",
      AppStrings.prepareBeforeUmrahHeadingTxt:
      "عمرہ ادا کرنے سے پہلے تیاری کریں",
      AppStrings.checkTravelDocumentsTxt: "سفر کے کاغذات چیک کریں",
      AppStrings.packSmartlyTxt: "سامان سمجھداری سے پیک کریں",
      AppStrings.checkUmrahPackageDetailsTxt:
      "اپنے عمرہ پیکج کی تفصیلات چیک کریں",
      AppStrings.howToPerformUmrahHeadingTxt:
      "عمرہ کیسے ادا کریں - مرحلہ وار رہنمائی",
      AppStrings.methodOfPuttingIhramTxt: "احرام باندھنے کا طریقہ",
      AppStrings.checkTravelDocumentsTitleTxt:
      "سفر کے کاغذات چیک کریں",
      AppStrings.travelDocPassportValidityTxt: "1. پاسپورٹ کی معیاد",
      AppStrings.travelDocVisaRequirementsTxt: "2. ویزا کے تقاضے",
      AppStrings.travelDocFlightDetailsTxt: "3. فلائٹ کی تفصیلات",
      AppStrings.travelDocHotelBookingTxt: "4. ہوٹل بُکنگ کی تصدیق",

      /// Onboarding
      AppStrings.onboardingTitle1Txt: "حج و عمرہ کی تیاری کریں",
      AppStrings.onboardingSubtitle1Txt:
      "حج و عمرہ درست طریقے سے ادا کرنے کے لیے ضروری رہنمائی اور مراحل",
      AppStrings.onboardingTitle2Txt: "دعاؤں اور زیارات کا ذخیرہ",
      AppStrings.onboardingSubtitle2Txt:
      "طاقتور دعائیں، اذکار اور تفصیلی زیارات گائیڈز تک آسان رسائی",
      AppStrings.onboardingTitle3Txt: "نقشے کے ساتھ اپنی زیارت منصوبہ بنائیں",
      AppStrings.onboardingSubtitle3Txt:
      "ہمارے انٹرایکٹو نقشے کے ساتھ حج، عمرہ اور دیگر زیارات کے مقامات تلاش کریں",
      AppStrings.onboardingGetStartedBtnTxt: "شروع کریں",
      AppStrings.onboardingNextBtnTxt: "اگلا",
      AppStrings.onboardingExploreNowBtnTxt: "ابھی دیکھیں",
      AppStrings.onboardingSkipTxt: "اسکپ",

      /// Tasbih Counter
      AppStrings.tasbihAppBarTitleTxt: "ذکر",
      AppStrings.resetCounterTitleTxt: "کاؤنٹر ری سیٹ کریں؟",
      AppStrings.resetCounterSubtitleTxt:
      "کیا آپ واقعی کاؤنٹر ری سیٹ کرنا چاہتے ہیں؟ یہ عمل واپس نہیں ہو سکے گا۔",
      AppStrings.cancelBtnLabelTxt: "منسوخ کریں",
      AppStrings.yesResetBtnLabelTxt: "ہاں، ری سیٹ کریں",
      AppStrings.tasbihAyahArabicTxt:
      "أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ",
      AppStrings.tasbihAyahTranslationTxt:
      "یاد رکھو! اللہ کے ذکر سے ہی دلوں کو سکون ملتا ہے۔",

      /// Haram Gates
      AppStrings.haramGatesAppBarTitleTxt: "حرم گیٹس",
      AppStrings.haramGatesInfoHeadingTxt: "حرم گیٹس کی معلومات",
      AppStrings.haramGateKingFahadEnTxt: "King Fahad Gate",
      AppStrings.haramGateKingFahadArTxt: "باب الملك فهد",
      AppStrings.haramGateKingFahadDescTxt:
      "گیٹ 79: بڑا مشرقی دروازہ جو اکثر براہِ راست مطاف تک آسان رسائی کے لیے استعمال ہوتا ہے۔",
      AppStrings.haramGateKingAbdulAzizEnTxt: "King Abdul Aziz Gate",
      AppStrings.haramGateKingAbdulAzizArTxt: "باب الملك عبدالعزيز",
      AppStrings.haramGateKingAbdulAzizDescTxt:
      "گیٹ 1: مسجد الحرام کے اہم دروازوں میں سے ایک، جو شمالی جانب واقع ہے۔",
      AppStrings.haramGateBabAlSalamEnTxt: "Bab Al Salam",
      AppStrings.haramGateBabAlSalamArTxt: "باب السلام",
      AppStrings.haramGateBabAlSalamDescTxt:
      "گیٹ 2: باب السلام، ایک تاریخی دروازہ جسے صدیوں سے حجاج استعمال کرتے آئے ہیں۔",
      AppStrings.haramGateBabAlUmrahEnTxt: "Bab Al Umrah",
      AppStrings.haramGateBabAlUmrahArTxt: "باب العمرة",
      AppStrings.haramGateBabAlUmrahDescTxt:
      "گیٹ 3: اکثر عمرہ ادا کرنے والوں کے لیے مسجد الحرام میں داخلے کا دروازہ۔",
      AppStrings.haramGateBabIbrahimEnTxt: "Bab Ibrahim",
      AppStrings.haramGateBabIbrahimArTxt: "باب إبراهيم",
      AppStrings.haramGateBabIbrahimDescTxt:
      "گیٹ 4: نبی اللہ ابراہیم علیہ السلام کے نام پر، مسجد کے مغربی جانب واقع۔",
      AppStrings.closeBottomSheetBtnTxt: "بند کریں",
      AppStrings.exitAppTitleTxt: "ایپ بند کریں؟",
      AppStrings.exitAppSubtitleTxt:
      "کیا آپ ایپ بند کرنا چاہتے ہیں یا اسی اسکرین پر رہنا چاہتے ہیں؟",
      AppStrings.stayBtnLabelTxt: "رہیں",
      AppStrings.exitBtnLabelTxt: "بند کریں",
      AppStrings.updateAvailableTitleTxt: "اپ ڈیٹ دستیاب ہے",
      AppStrings.updateAvailableSubtitleTxt:
      "زیارتِ حرمین کا نیا ورژن دستیاب ہے جس میں بہتر فیچرز اور آپ کے روحانی سفر کے لیے مزید بہتر تجربہ شامل ہے۔",
      AppStrings.updateLaterBtnTxt: "بعد میں",
      AppStrings.updateNowBtnTxt: "ابھی اپ ڈیٹ کریں",

      /// FAQ Screen
      AppStrings.faqAppBarTitleTxt: "عمرہ سے متعلق سوالات",
      AppStrings.faqIntroTxt:
      "عمرہ کی منصوبہ بندی سے پہلے لوگوں کے ذہن میں آنے والے چند عام سوالات:",
      AppStrings.hajjFaqAppBarTitleTxt: "حج سے متعلق سوالات",
      AppStrings.hajjFaqIntroTxt:
      "حج کی منصوبہ بندی سے پہلے لوگوں کے ذہن میں آنے والے چند عام سوالات:",
      AppStrings.maintenanceTitleTxt:
      "زیارتِ حرمین اس وقت دیکھ بھال میں ہے!",
      AppStrings.maintenanceDescriptionTxt:
      "ہم آپ کے روحانی سفر کے تجربے کو بہتر بنانے کے لیے ایپ میں بہتری کر رہے ہیں۔\nان شاء اللہ ہم جلد واپس آئیں گے۔\nآپ کے صبر کا شکریہ۔",
      AppStrings.faqQ1Txt: "کیا عمرہ سال کے کسی بھی وقت ادا کیا جا سکتا ہے؟",
      AppStrings.faqA1Txt:
      "جی ہاں، عمرہ سال کے کسی بھی وقت کیا جا سکتا ہے، سوائے مخصوص ایامِ حج کے جب حجاج حج کے ارکان میں مصروف ہوتے ہیں۔",
      AppStrings.faqQ2Txt: "حج اور عمرہ میں کیا فرق ہے؟",
      AppStrings.faqA2Txt:
      "حج صاحبِ استطاعت مسلمان پر زندگی میں ایک مرتبہ فرض ہے اور مخصوص تاریخوں میں ادا کیا جاتا ہے، جبکہ عمرہ نفل عبادت ہے اور سال کے کسی بھی وقت ادا کیا جا سکتا ہے۔",
      AppStrings.faqQ3Txt: "عمرہ کے لیے کیا پہننا چاہیے؟",
      AppStrings.faqA3Txt:
      "مرد دو سفید غیر سلے کپڑے (ازار و ردا) یعنی احرام پہنیں، اور عورتیں ڈھیلا، باوقار لباس پہنیں جو پورے جسم کو ڈھانپتا ہو سوائے چہرے اور ہاتھوں کے۔",
      AppStrings.faqQ4Txt: "عمرہ میں کتنا وقت لگتا ہے؟",
      AppStrings.faqA4Txt:
      "بہت سے لوگوں کے لیے عمرہ عموماً 2 سے 5 گھنٹے میں مکمل ہو جاتا ہے، یہ ہجوم اور آپ کی رفتار پر منحصر ہے۔",

      /// Method of Putting Ihram detail
      AppStrings.methodOfPuttingIhramDescriptionTxt:
      "یہ متن احرام باندھنے کے طریقہ کار کے لیے پلیس ہولڈر ہے۔ آپ بعد میں مستند اردو متن شامل کر سکتے ہیں جو احرام کی عملی تفصیلات بیان کرے۔",

      /// Paged list / search states
      AppStrings.noItemsFoundTxt: "کوئی آئٹم نہیں ملا۔",
      AppStrings.noResultsFoundTxt: "کوئی نتیجہ نہیں ملا۔",
      AppStrings.errorLoadingDataTxt: "ڈیٹا لوڈ کرنے میں خرابی۔",
      AppStrings.retryBtnTxt: "دوبارہ کوشش کریں",

      /// Common Mistakes - See More
      AppStrings.commonMistakesSeeMorTxt: "[مزید جانیے]",
    },
  };
}