// lib/presentation/pages/shared/faq_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/constants/asset_constant.dart';
import 'package:ziarat_app/presentation/constants/app_strings.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import '../../../application/navigation_helper.dart';
import '../../../infrastructure/models/masail.dart';
import '../../../configurations/frontend_config.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Lightweight interface so the bottom sheet works with both MasailModel
// and CommonMistakeModel without duplicating the widget.
// ─────────────────────────────────────────────────────────────────────────────

abstract class FaqItem {
  String getLocalizedQuestion(String languageCode);
  String getLocalizedAnswer(String languageCode);
  String get category;
}

extension MasailAsFaqItem on MasailModel {
  FaqItem asFaqItem() => _MasailFaqItem(this);
}

extension CommonMistakeAsFaqItem on CommonMistakeModel {
  FaqItem asFaqItem() => _CommonMistakeFaqItem(this);
}

class _MasailFaqItem implements FaqItem {
  final MasailModel _m;
  const _MasailFaqItem(this._m);

  @override
  String getLocalizedQuestion(String languageCode) =>
      _m.getLocalizedQuestion(languageCode);

  @override
  String getLocalizedAnswer(String languageCode) =>
      _m.getLocalizedAnswer(languageCode);

  @override
  String get category => _m.category;
}

class _CommonMistakeFaqItem implements FaqItem {
  final CommonMistakeModel _m;
  const _CommonMistakeFaqItem(this._m);

  @override
  String getLocalizedQuestion(String languageCode) =>
      _m.getLocalizedQuestion(languageCode);

  @override
  String getLocalizedAnswer(String languageCode) =>
      _m.getLocalizedAnswer(languageCode);

  @override
  String get category => _m.category;
}

// ─────────────────────────────────────────────────────────────────────────────

class FaqBottomSheet extends StatelessWidget {
  final int number;
  final FaqItem faq;

  const FaqBottomSheet({
    super.key,
    required this.number,
    required this.faq,
  });

  // ── Convenience show() overloads ──────────────────────────────────────────

  /// Show with a MasailModel (Q&A tab, Women's Guide tab)
  static void show(BuildContext context, int number, MasailModel faq) {
    _open(context, number, faq.asFaqItem());
  }

  /// Show with a CommonMistakeModel (Common Mistakes tab)
  static void showMistake(
      BuildContext context, int number, CommonMistakeModel mistake) {
    _open(context, number, mistake.asFaqItem());
  }

  static void _open(BuildContext context, int number, FaqItem item) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FaqBottomSheet(number: number, faq: item),
    );
  }

  /// Helper: Get font family based on locale
  String _getFontFamily() {
    final locale = Get.locale?.languageCode;
    if (locale == 'ar') return 'noto-sans';
    if (locale == 'ur') return 'jameel-noori';
    return 'Raleway';
  }

  @override
  Widget build(BuildContext context) {
    final lang = Get.locale?.languageCode ?? 'en';
    final localizedQuestion = faq.getLocalizedQuestion(lang);
    final localizedAnswer = faq.getLocalizedAnswer(lang);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
      child: MyContainer(
        decoration: BoxDecoration(
          gradient: FrontEndConfig.btnBorderColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: MyContainer(
            height: MediaQuery.of(context).size.height * 0.50,
            decoration: BoxDecoration(
              color: FrontEndConfig.backgroundColor,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  // ── Background image ──
                  Positioned.fill(
                    child: Image.asset(
                      AssetConstant.bottomSheetDesgin,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // ── Content ──
                  Positioned.fill(
                    child: Column(
                      children: [
                        // ── Fixed drag handle at top ──
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 89,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── Scrollable area (number, badge, question, answer) ──
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                // ── Question number ──
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xffC89C18)
                                        .withOpacity(0.3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "$number",
                                      style: TextStyle(
                                        color: FrontEndConfig.textColor,
                                        fontSize: FrontEndConfig.fontSize(22),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: _getFontFamily(),
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // ── Category badge ──
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffC89C18)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    faq.category,
                                    style: TextStyle(
                                      color: const Color(0xffC89C18),
                                      fontSize: FrontEndConfig.fontSize(10),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: _getFontFamily(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // ── Question / Title ──
                                Text(
                                  localizedQuestion,
                                  textAlign: TextAlign.center,
                                  style: FrontEndConfig.mainTextStyle.copyWith(
                                    fontFamily: _getFontFamily(),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // ── Answer / Content ──
                                Text(
                                  localizedAnswer,
                                  textAlign: TextAlign.center,
                                  style: FrontEndConfig.bodyTextStyle.copyWith(
                                    fontFamily: _getFontFamily(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),

                        // ── Fixed close button at bottom ──
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextButton(
                            onPressed: () => NavigatorHelper.pop(context),
                            child: Text(
                              AppStrings.closeBottomSheetBtnTxt.tr,
                              style: FrontEndConfig.headingTextStyle.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
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
      ),
    );
  }
}