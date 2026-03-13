import 'package:get/get.dart';

import '../constants/app_strings.dart';

class StringConstantAr extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar_SA': {
          // For now, Arabic values mirror English; replace with real Arabic later.

          /// Core
          AppStrings.appTitle: 'تطبيق الزيارات',

          /// General / Common
          AppStrings.umrahMasailScreenTxt: "مسائل العمرة",
          AppStrings.settingsTitleTxt: "الإعدادات",
          AppStrings.manageSettingsHeadingTxt: "إدارة الإعدادات",
          AppStrings.appFeaturesHeadingTxt: "مزايا التطبيق",
          AppStrings.appOverviewHeadingTxt: "نظaرة عامة على التطبيق",
          AppStrings.aboutUsTxt: "من نحن",
          AppStrings.rateOurAppTxt: "قيّم التطبيق",
          AppStrings.helpAndSupportTxt: "المساعدة والدعم",
          AppStrings.couldNotOpenEmailAppTxt: "تعذر فتح تطبيق البريد",
          AppStrings.couldNotOpenWebsiteTxt: "تعذر فتح الموقع",

          /// Bottom navigation / routes (Extra screen)
          AppStrings.extraScreenTitleTxt: "إضافات",
          AppStrings.bottomBarTxt: "الشريط السفلي",
          AppStrings.homeScreenTxt: "الرئيسية",
          AppStrings.languageScreenTxt: "اللغة",
          AppStrings.ziyaratScreenTxt: "الزيارات",
          AppStrings.networkProviderScreenTxt: "مزود الشبكة",
          AppStrings.packageDetailsScreenTxt: "تفاصيل الباقة",
          AppStrings.tasbihCounterScreenTxt: "عداد التسبيح",
          AppStrings.umrahGuideScreenTxt: "دليل العمرة",
          AppStrings.privacyPolicyScreenTxt: "سياسة الخصوصية",
          AppStrings.termsAndConditionsScreenTxt: "الشروط والأحكام",
          AppStrings.faqScreenTxt: "الأسئلة الشائعة",
          AppStrings.haramGatesScreenTxt: "بوابات الحرم",

          /// Language screen
          AppStrings.selectLanguageHeadingTxt: "اختر اللغة",
          AppStrings.choosePreferredLanguageDescriptionTxt:
              "اختر لغتك المفضلة للمتابعة",
          AppStrings.languageEnglishTxt: "الإنجليزية",
          AppStrings.languageUrduTxt: "الأردية",
          AppStrings.languageArabicTxt: "العربية",
          AppStrings.continueBtnText: "متابعة",

          /// Home screen
          AppStrings.fallbackLocationMakkahSaudiArabiaTxt: "مكة، السعودية",
          AppStrings.nextPrayerLabelTxt: "الصلاة القادمة:",
          AppStrings.remainingLabelTxt: "المتبقي:",
          AppStrings.ayatOfTheDayTxt: "آية اليوم",
          AppStrings.hadithOfTheDayTxt: "حديث اليوم",
          AppStrings.prayerTimesTxt: "مواقيت الصلاة",

          /// Ziarat listing
          AppStrings.ziyaratAppBarTitleTxt: "الزيارات",
          AppStrings.searchZiyaratHintTxt: "ابحث عن زيارة...",
          AppStrings.makkahTabTxt: "مكة",
          AppStrings.madinaTabTxt: "المدينة",
          AppStrings.noResultsFoundTxt: "لا توجد نتائج",
          AppStrings.seeMoreSuffixTxt: " عرض المزيد",

          /// Ziarat details
          AppStrings.noAudioGuideAvailableTxt: "لا يوجد دليل صوتي متاح",
          AppStrings.failedToPlayAudioTxt: "فشل تشغيل الصوت",
          AppStrings.historicalBackgroundHeadingTxt: "الخلفية التاريخية",
          AppStrings.richTextThePrefixTxt: "الـ",
          AppStrings.recommendedDuaHeadingTxt: "الدعاء الموصى به",
          AppStrings.closeBtnTxt: "إغلاق",

          /// SIM / Network provider
          AppStrings.networkProvidersAppBarTitleTxt: "مزودو الشبكة",
          AppStrings.simInfoHeadingTxt: "معلومات الشريحة",
          AppStrings.simInfoDescriptionTxt:
              "ابقَ على اتصال مع العائلة. أغلب الأكشاك تقع في مطار الملك عبدالعزيز بجدة.",
          AppStrings.listOfProvidersHeadingTxt: "قائمة المزودين",
          AppStrings.helplineLabelTxt: "الخط الساخن:",
          AppStrings.requirementsForSimHeadingTxt: "متطلبات الشريحة",
          AppStrings.requirementPassportValidityTxt:
              "1. صلاحية جواز السفر مع ختم الدخول.",
          AppStrings.requirementFingerprintVerificationTxt:
              "2. التحقق من البصمة في الكاونتر.",
          AppStrings.requirementUsuallyActiveTxt:
              "3. يتم التفعيل عادة خلال 30 دقيقة.",
          AppStrings.requirementGetSimsJeddahTxt:
              "4. يمكنك الحصول على شرائح بسهولة من مطار جدة.",

          /// Package details
          AppStrings.gbsLabelTxt: "جيجابايت",
          AppStrings.onNetMinutesLabelTxt: "دقائق داخل الشبكة",
          AppStrings.internationalMinutesLabelTxt: "دقائق دولية",
          AppStrings.smsLabelTxt: "رسائل SMS",

          /// Generic / Error
          AppStrings.genericSomethingWentWrongTxt: "حدث خطأ ما",

          /// Umrah guide
          AppStrings.umrahGuideAppBarTitleTxt: "دليل العمرة",
          AppStrings.prepareBeforeUmrahHeadingTxt: "استعد قبل أداء العمرة",
          AppStrings.checkTravelDocumentsTxt: "فحص وثائق السفر",
          AppStrings.packSmartlyTxt: "الاستعداد للأمتعة",
          AppStrings.checkUmrahPackageDetailsTxt:
              "فحص تفاصيل باقة العمرة الخاصة بك",
          AppStrings.howToPerformUmrahHeadingTxt:
              "كيفية أداء العمرة خطوة بخطوة",
          AppStrings.methodOfPuttingIhramTxt: "طريقة ارتداء الإحرام",
          AppStrings.checkTravelDocumentsTitleTxt: "فحص وثائق السفر",
          AppStrings.travelDocPassportValidityTxt: "1. صلاحية جواز السفر",
          AppStrings.travelDocVisaRequirementsTxt: "2. متطلبات التأشيرة",
          AppStrings.travelDocFlightDetailsTxt: "3. تفاصيل الرحلة",
          AppStrings.travelDocHotelBookingTxt: "4. تأكيد حجز الفندق",

          /// Onboarding
          AppStrings.onboardingTitle1Txt: "استعد للحج والعمرة",
          AppStrings.onboardingSubtitle1Txt:
              "أدلة أساسية وخطوات لمساعدتك على أداء الحج والعمرة بشكل صحيح",
          AppStrings.onboardingTitle2Txt: "اكتشف الأدعية والزيارات",
          AppStrings.onboardingSubtitle2Txt:
              "وصول سهل للأدعية القوية والصلوات الإسلامية وأدلة الزيارات التفصيلية",
          AppStrings.onboardingTitle3Txt: "خطط لزيارتك مع الخريطة",
          AppStrings.onboardingSubtitle3Txt:
              "استكشف مواقع الحج والعمرة والزيارات بخريطتنا التفاعلية",
          AppStrings.onboardingGetStartedBtnTxt: "ابدأ الآن",
          AppStrings.onboardingNextBtnTxt: "التالي",
          AppStrings.onboardingExploreNowBtnTxt: "استكشف الآن",
          AppStrings.onboardingSkipTxt: "تخطي",

          /// Tasbih Counter
          AppStrings.tasbihAppBarTitleTxt: "الذِكر",
          AppStrings.resetCounterTitleTxt: "إعادة تعيين العداد؟",
          AppStrings.resetCounterSubtitleTxt:
              "هل أنت متأكد أنك تريد إعادة تعيين العداد؟ لا يمكن التراجع عن هذا الإجراء.",
          AppStrings.cancelBtnLabelTxt: "إلغاء",
          AppStrings.yesResetBtnLabelTxt: "نعم، إعادة",
          AppStrings.tasbihAyahArabicTxt:
              "أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ",
          AppStrings.tasbihAyahTranslationTxt:
              "أَلَا بِذِكْرِ اللهِ تَطْمَئِنُّ الْقُلُوبُ",

          /// Haram Gates
          AppStrings.haramGatesAppBarTitleTxt: "بوابات الحرم",
          AppStrings.haramGatesInfoHeadingTxt: "معلومات بوابات الحرم",
          AppStrings.haramGateKingFahadEnTxt: "King Fahad Gate",
          AppStrings.haramGateKingFahadArTxt: "باب الملك فهد",
          AppStrings.haramGateKingFahadDescTxt:
              "البوابة 79: مدخل شرقي كبير يستخدم غالبًا للوصول المباشر إلى المطاف.",
          AppStrings.haramGateKingAbdulAzizEnTxt: "King Abdul Aziz Gate",
          AppStrings.haramGateKingAbdulAzizArTxt: "باب الملك عبدالعزيز",
          AppStrings.haramGateKingAbdulAzizDescTxt:
              "البوابة 1: إحدى المداخل الرئيسية للمسجد الحرام، تقع في الجهة الشمالية.",
          AppStrings.haramGateBabAlSalamEnTxt: "Bab Al Salam",
          AppStrings.haramGateBabAlSalamArTxt: "باب السلام",
          AppStrings.haramGateBabAlSalamDescTxt:
              "البوابة 2: باب السلام، مدخل تاريخي استخدمه الحجاج لقرون.",
          AppStrings.haramGateBabAlUmrahEnTxt: "Bab Al Umrah",
          AppStrings.haramGateBabAlUmrahArTxt: "باب العمرة",
          AppStrings.haramGateBabAlUmrahDescTxt:
              "البوابة 3: تُستخدم غالبًا من قبل المعتمرين لدخول المسجد الحرام.",
          AppStrings.haramGateBabIbrahimEnTxt: "Bab Ibrahim",
          AppStrings.haramGateBabIbrahimArTxt: "باب إبراهيم",
          AppStrings.haramGateBabIbrahimDescTxt:
              "البوابة 4: سميت على اسم نبي الله إبراهيم، تقع في الجهة الغربية من المسجد.",
          AppStrings.closeBottomSheetBtnTxt: "إغلاق",

          /// FAQ Screen
          AppStrings.faqAppBarTitleTxt: "أسئلة حول العمرة",
          AppStrings.faqIntroTxt:
              "بعض الأسئلة الشائعة حول العمرة التي يسألها الناس عادة قبل التخطيط لرحلتهم:",
          AppStrings.faqQ1Txt: "هل يمكن أداء العمرة في أي وقت؟",
          AppStrings.faqA1Txt:
              "نعم، يمكن أداء العمرة في أي وقت من السنة، باستثناء أيام محددة للحج حيث ينشغل الحجاج بمناسك الحج.",
          AppStrings.faqQ2Txt: "ما الفرق بين الحج والعمرة؟",
          AppStrings.faqA2Txt:
              "الحج ركن واجب مرة واحدة في العمر لمن استطاع، ويؤدى في أيام محددة. أما العمرة فهي نافلة ويمكن أداؤها في أي وقت.",
          AppStrings.faqQ3Txt: "ماذا أرتدي في العمرة؟",
          AppStrings.faqA3Txt:
              "يرتدي الرجال إزارًا ورداءً أبيضين غير مخيطين يسمى الإحرام، والنساء يرتدين لباسًا ساترًا فضفاضًا لا يغطي الوجه واليدين.",
          AppStrings.faqQ4Txt: "كم يستغرق أداء العمرة؟",
          AppStrings.faqA4Txt:
              "غالبًا ما تستغرق العمرة من ساعتين إلى خمس ساعات حسب الازدحام وسرعتك.",

          /// Method of Putting Ihram detail
          AppStrings.methodOfPuttingIhramDescriptionTxt:
              "هذا النص مكان وصف طريقة ارتداء الإحرام. يمكنك استبداله لاحقًا بنص عربي موثوق يشرح خطوات الإحرام بالتفصيل.",
        },
      };
}

