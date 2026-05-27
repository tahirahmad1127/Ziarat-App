import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import 'package:ziarat_app/presentation/views/umrah_guide/method_putting_ihram.dart';

import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import '../../../infrastructure/models/hajj_package_details.dart';
import '../../../infrastructure/models/hajj_saman.dart';
import '../../../infrastructure/models/hajj_travel_docs.dart';
import '../../../infrastructure/models/umrah_package_details.dart';
import '../../../infrastructure/models/umrah_saman.dart';
import '../../../infrastructure/models/umrah_travel_docs.dart';
import '../../../infrastructure/services/hajj_saman.dart';
import '../../../infrastructure/services/hajj_travel_docs.dart';
import '../../../infrastructure/services/umrah_saman.dart';
import '../../../infrastructure/services/hajj_package_detail.dart';
import '../../../infrastructure/services/umrah_package_detail.dart';
import '../../../infrastructure/services/umrah_travel_docs.dart';
import '../../constants/asset_constant.dart';
import '../../elements/listTile.dart';
import '../../constants/app_strings.dart';
import '../faqs_screen/umrah_faq_screen.dart';
import '../faqs_screen/hajj_faq_screen.dart';

class Guide extends StatefulWidget {
  const Guide({super.key});

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Helper: Get font family based on locale
  String _getFontFamily() {
    final locale = Get.locale?.languageCode;
    if (locale == 'ar') return 'noto-sans';
    if (locale == 'ur') return 'jameel-noori';
    return 'Raleway';
  }

  /// Localized guide tab labels
  String _guideTabLabel(bool isHajj) {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ar') return isHajj ? 'دليل الحج' : 'دليل العمرة';
    if (lang == 'ur') return isHajj ? 'حج گائیڈ' : 'عمرہ گائیڈ';
    return isHajj ? 'Hajj Guide' : 'Umrah Guide';
  }

  /// Localized label for the essentials tile
  String _essentialsLabel({required bool isHajj}) {
    final lang = Get.locale?.languageCode ?? 'en';
    if (isHajj) {
      if (lang == 'ur') return 'حج سامان';
      if (lang == 'ar') return 'مستلزمات الحج';
      return 'Hajj Essentials';
    } else {
      if (lang == 'ur') return 'عمرہ سامان';
      if (lang == 'ar') return 'مستلزمات العمرة';
      return 'Umrah Essentials';
    }
  }

  /// Localized label for the package details tile
  String _packageDetailsLabel({required bool isHajj}) {
    final lang = Get.locale?.languageCode ?? 'en';
    if (isHajj) {
      if (lang == 'ur') return 'حج پیکیج تفصیلات';
      if (lang == 'ar') return 'تفاصيل باقة الحج';
      return 'Hajj Package Details';
    } else {
      if (lang == 'ur') return 'عمرہ پیکیج تفصیلات';
      if (lang == 'ar') return 'تفاصيل باقة العمرة';
      return 'Umrah Package Details';
    }
  }

  /// Localized label for the travel docs tile
  String _travelDocsLabel({required bool isHajj}) {
    final lang = Get.locale?.languageCode ?? 'en';
    if (isHajj) {
      if (lang == 'ur') return 'حج سفری دستاویزات';
      if (lang == 'ar') return 'وثائق سفر الحج';
      return 'Hajj Travel Documents';
    } else {
      if (lang == 'ur') return 'عمرہ سفری دستاویزات';
      if (lang == 'ar') return 'وثائق سفر العمرة';
      return 'Umrah Travel Documents';
    }
  }

  String _replaceGuideWord(String text, bool isHajj) {
    if (!isHajj) return text;
    return text
        .replaceAll('Umrah', 'Hajj')
        .replaceAll('umrah', 'hajj')
        .replaceAll('عمرہ', 'حج')
        .replaceAll('العمرة', 'الحج');
  }

  Widget _buildNumberCircle(String number) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xffC89C18).withOpacity(0.3),
      ),
      child: Center(
        child: Text(
          number,
          style: GoogleFonts.raleway(
            color: FrontEndConfig.textColor,
            fontSize: FrontEndConfig.fontSize(16),
            fontWeight: FontWeight.w500,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildGuideContent(BuildContext context, {required bool isHajj}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _replaceGuideWord(
                AppStrings.prepareBeforeUmrahHeadingTxt.tr, isHajj),
            style: FrontEndConfig.mainTextStyle
                .copyWith(fontSize: FrontEndConfig.fontSize(18)),
          ),
          0.02.height(context),

          // ── Essentials tile ─────────────────────────────────────────────
          CommonListTile(
            tileColor: FrontEndConfig.listTileColor,
            borderGradient: FrontEndConfig.listTileBorder,
            image: AssetConstant.documentIcon,
            title: _essentialsLabel(isHajj: isHajj),
            trailing:
            Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
            onTap: () => isHajj
                ? HajjSamanSheet.show(context)
                : UmrahSamanSheet.show(context),
          ),
          0.02.height(context),

          // ── Pack Smartly tile ────────────────────────────────────────────
          CommonListTile(
            tileColor: FrontEndConfig.listTileColor,
            borderGradient: FrontEndConfig.listTileBorder,
            image: AssetConstant.packIcon,
            title: AppStrings.packSmartlyTxt.tr,
            trailing:
            Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
            onTap: () {},
          ),
          0.02.height(context),

          // ── Package Details tile ─────────────────────────────────────────
          CommonListTile(
            tileColor: FrontEndConfig.listTileColor,
            borderGradient: FrontEndConfig.listTileBorder,
            image: AssetConstant.bagListIcon,
            title: _packageDetailsLabel(isHajj: isHajj),
            trailing:
            Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
            onTap: () => isHajj
                ? HajjPackageDetailSheet.show(context)
                : UmrahPackageDetailSheet.show(context),
          ),
          0.02.height(context),

          // ── Travel Documents tile ────────────────────────────────────────
          CommonListTile(
            tileColor: FrontEndConfig.listTileColor,
            borderGradient: FrontEndConfig.listTileBorder,
            image: AssetConstant.aeroplaneIcon,
            title: _travelDocsLabel(isHajj: isHajj),
            trailing:
            Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
            onTap: () => isHajj
                ? HajjTravelSheet.show(context)
                : UmrahTravelSheet.show(context),
          ),
          0.02.height(context),

          Text(
            _replaceGuideWord(
                AppStrings.howToPerformUmrahHeadingTxt.tr, isHajj),
            style: FrontEndConfig.mainTextStyle
                .copyWith(fontSize: FrontEndConfig.fontSize(18)),
          ),
          0.02.height(context),

          CommonListTile(
            tileColor: FrontEndConfig.listTileColor,
            borderGradient: FrontEndConfig.listTileBorder,
            leading: _buildNumberCircle("1"),
            title: _replaceGuideWord(
                AppStrings.methodOfPuttingIhramTxt.tr, isHajj),
            onTap: () {
              NavigatorHelper.push(context, MethodPuttingIhram());
            },
          ),
          0.02.height(context),

          CommonListTile(
            tileColor: FrontEndConfig.listTileColor,
            borderGradient: FrontEndConfig.listTileBorder,
            leading: _buildNumberCircle("2"),
            title: _replaceGuideWord(
                AppStrings.methodOfPuttingIhramTxt.tr, isHajj),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),
          Positioned.fill(
            child: Image.asset(AssetConstant.backgroundimage,
                fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10.0),
                  child: CommonAppBar(
                    title: AppStrings.guideAppBarTitleTxt.tr,
                    color: FrontEndConfig.iconColor,
                    showLeading: false,
                    actionIcon: AssetConstant.helpIcon,
                    onActionTap: () {
                      NavigatorHelper.push(
                        context,
                        _tabController.index == 0
                            ? const UmrahFaqScreen()
                            : const HajjFaqScreen(),
                      );
                    },
                  ),
                ),
                0.02.height(context),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: MyContainer(
                    height: 50,
                    gradient: FrontEndConfig.btnBorderColor,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: MyContainer(
                        decoration: BoxDecoration(
                          color:
                          FrontEndConfig.backgroundColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          unselectedLabelColor: FrontEndConfig.textColor,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: FrontEndConfig.btnBorderColor,
                          ),
                          labelColor: FrontEndConfig.textColor,
                          tabs: [
                            Tab(
                              child: Text(
                                _guideTabLabel(false),
                                style: TextStyle(
                                  fontSize: FrontEndConfig.fontSize(14),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: _getFontFamily(),
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                _guideTabLabel(true),
                                style: TextStyle(
                                  fontSize: FrontEndConfig.fontSize(14),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: _getFontFamily(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildGuideContent(context, isHajj: false),
                      _buildGuideContent(context, isHajj: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared bottom-sheet base ─────────────────────────────────────────────────
//
// All four sheets share identical layout/style logic. The generic
// _BaseContentSheet<T> handles loading / error / retry / HTML rendering.
// Each concrete sheet just provides a title, icon, and fetch callback.

typedef _FetchFn<T> = Future<T?> Function();

class _BaseContentSheet<T> extends StatefulWidget {
  final String sheetTitle;
  final _FetchFn<T> fetchData;
  final String Function(T data) getLocalizedContent;

  const _BaseContentSheet({
    super.key,
    required this.sheetTitle,
    required this.fetchData,
    required this.getLocalizedContent,
  });

  @override
  State<_BaseContentSheet<T>> createState() => _BaseContentSheetState<T>();
}

class _BaseContentSheetState<T> extends State<_BaseContentSheet<T>> {
  bool _isLoading = true;
  String? _errorMessage;
  T? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final result = await widget.fetchData();
      if (!mounted) return;
      setState(() {
        _data = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  bool get _isRtl {
    final lang = Get.locale?.languageCode ?? 'en';
    return lang == 'ar' || lang == 'ur';
  }

  String _getFontFamily() {
    final locale = Get.locale?.languageCode;
    if (locale == 'ar') return 'noto-sans';
    if (locale == 'ur') return 'jameel-noori';
    return 'Raleway';
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final double maxHeight = MediaQuery.of(context).size.height * 0.70;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
        EdgeInsets.only(left: 16, right: 16, bottom: 25 + bottomPadding),
        child: MyContainer(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: FrontEndConfig.btnBorderColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: MyContainer(
                width: double.infinity,
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
                  borderRadius: BorderRadius.circular(13),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          AssetConstant.bottomSheetDesgin,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Directionality(
                            textDirection: _isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: 89,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                0.02.height(context),
                                Center(
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                    const Color(0xffC89C18).withOpacity(0.3),
                                    child: Image.asset(
                                      AssetConstant.documentIcon,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                                0.02.height(context),
                                Center(
                                  child: Text(
                                    widget.sheetTitle,
                                    style: FrontEndConfig.mainTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                0.015.height(context),
                                _buildBody(context),
                                0.04.height(context),
                                Center(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 8.0),
                                    child: GestureDetector(
                                      onTap: () =>
                                          NavigatorHelper.pop(context),
                                      child: Text(
                                        AppStrings.closeBottomSheetBtnTxt.tr,
                                        textAlign: TextAlign.center,
                                        style: FrontEndConfig.headingTextStyle
                                            .copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                          decorationThickness: 2,
                                          height: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xffC89C18),
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              Text(
                _errorMessage!,
                style: FrontEndConfig.bodyTextStyle
                    .copyWith(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _load();
                },
                child: Text(
                  AppStrings.retryBtnTxt.tr,
                  style: FrontEndConfig.bodyTextStyle.copyWith(
                    color: const Color(0xffC89C18),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xffC89C18),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_data == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            AppStrings.noItemsFoundTxt.tr,
            style: FrontEndConfig.bodyTextStyle,
          ),
        ),
      );
    }

    return Html(
      data: widget.getLocalizedContent(_data as T),
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: FrontEndConfig.textColor,
          fontFamily: _getFontFamily(),
        ),
        "h1": Style(
          fontSize: FontSize(FrontEndConfig.fontSize(16)),
          fontWeight: FontWeight.w700,
          color: FrontEndConfig.textColor,
          margin: Margins.only(top: 12, bottom: 6),
          textAlign: _isRtl ? TextAlign.right : TextAlign.left,
        ),
        "h2": Style(
          fontSize: FontSize(FrontEndConfig.fontSize(15)),
          fontWeight: FontWeight.w600,
          color: FrontEndConfig.textColor,
          margin: Margins.only(top: 10, bottom: 4),
          textAlign: _isRtl ? TextAlign.right : TextAlign.left,
        ),
        "ul": Style(
          margin: _isRtl
              ? Margins.only(right: 8, bottom: 8)
              : Margins.only(left: 8, bottom: 8),
          padding: HtmlPaddings.zero,
        ),
        "li": Style(
          fontSize: FontSize(FrontEndConfig.fontSize(13)),
          color: FrontEndConfig.textColor,
          lineHeight: LineHeight(1.6),
          margin: Margins.only(bottom: 4),
          textAlign: _isRtl ? TextAlign.right : TextAlign.left,
        ),
        "p": Style(
          fontSize: FontSize(FrontEndConfig.fontSize(13)),
          color: FrontEndConfig.textColor,
          margin: Margins.only(bottom: 6),
          textAlign: _isRtl ? TextAlign.right : TextAlign.left,
        ),
      },
    );
  }
}

// ─── Helper: show any sheet ───────────────────────────────────────────────────

void _showSheet(BuildContext context, Widget sheet) {
  showModalBottomSheet(
    isDismissible: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: double.infinity),
    builder: (_) => sheet,
  );
}

// ─── Helper: resolve localized title ─────────────────────────────────────────

String _localizedTitle(
    {required String en, required String ur, required String ar}) {
  final lang = Get.locale?.languageCode ?? 'en';
  if (lang == 'ur') return ur;
  if (lang == 'ar') return ar;
  return en;
}

// ─── Hajj Saman Sheet ─────────────────────────────────────────────────────────

class HajjSamanSheet extends StatelessWidget {
  const HajjSamanSheet({super.key});

  static void show(BuildContext context) =>
      _showSheet(context, const HajjSamanSheet());

  @override
  Widget build(BuildContext context) {
    final repo = HajjSamanRepositoryImp();
    return _BaseContentSheet<HajjSamanData>(
      sheetTitle: _localizedTitle(
          en: 'Hajj Essentials', ur: 'حج سامان', ar: 'مستلزمات الحج'),
      fetchData: () async {
        final result = await repo.getHajjSaman();
        return result.fold(
              (l) => throw Exception(l.error),
              (r) => r.data?.isNotEmpty == true ? r.data!.first : null,
        );
      },
      getLocalizedContent: (data) => data.localizedContent,
    );
  }
}

// ─── Umrah Saman Sheet ────────────────────────────────────────────────────────

class UmrahSamanSheet extends StatelessWidget {
  const UmrahSamanSheet({super.key});

  static void show(BuildContext context) =>
      _showSheet(context, const UmrahSamanSheet());

  @override
  Widget build(BuildContext context) {
    final repo = UmrahSamanRepositoryImp();
    return _BaseContentSheet<UmrahSamanData>(
      sheetTitle: _localizedTitle(
          en: 'Umrah Essentials', ur: 'عمرہ سامان', ar: 'مستلزمات العمرة'),
      fetchData: () async {
        final result = await repo.getUmrahSaman();
        return result.fold(
              (l) => throw Exception(l.error),
              (r) => r.data?.isNotEmpty == true ? r.data!.first : null,
        );
      },
      getLocalizedContent: (data) => data.localizedContent,
    );
  }
}

// ─── Hajj Package Detail Sheet ────────────────────────────────────────────────

class HajjPackageDetailSheet extends StatelessWidget {
  const HajjPackageDetailSheet({super.key});

  static void show(BuildContext context) =>
      _showSheet(context, const HajjPackageDetailSheet());

  @override
  Widget build(BuildContext context) {
    final repo = HajjPackageDetailRepositoryImp();
    return _BaseContentSheet<HajjPackageDetailData>(
      sheetTitle: _localizedTitle(
          en: 'Hajj Package Details',
          ur: 'حج پیکیج تفصیلات',
          ar: 'تفاصيل باقة الحج'),
      fetchData: () async {
        final result = await repo.getHajjPackageDetail();
        return result.fold(
              (l) => throw Exception(l.error),
              (r) => r.data?.isNotEmpty == true ? r.data!.first : null,
        );
      },
      getLocalizedContent: (data) => data.localizedContent,
    );
  }
}

// ─── Umrah Package Detail Sheet ───────────────────────────────────────────────

class UmrahPackageDetailSheet extends StatelessWidget {
  const UmrahPackageDetailSheet({super.key});

  static void show(BuildContext context) =>
      _showSheet(context, const UmrahPackageDetailSheet());

  @override
  Widget build(BuildContext context) {
    final repo = UmrahPackageDetailRepositoryImp();
    return _BaseContentSheet<UmrahPackageDetailData>(
      sheetTitle: _localizedTitle(
          en: 'Umrah Package Details',
          ur: 'عمرہ پیکیج تفصیلات',
          ar: 'تفاصيل باقة العمرة'),
      fetchData: () async {
        final result = await repo.getUmrahPackageDetail();
        return result.fold(
              (l) => throw Exception(l.error),
              (r) => r.data?.isNotEmpty == true ? r.data!.first : null,
        );
      },
      getLocalizedContent: (data) => data.localizedContent,
    );
  }
}

// ─── Hajj Travel Sheet ────────────────────────────────────────────────────────

class HajjTravelSheet extends StatelessWidget {
  const HajjTravelSheet({super.key});

  static void show(BuildContext context) =>
      _showSheet(context, const HajjTravelSheet());

  @override
  Widget build(BuildContext context) {
    final repo = HajjTravelRepositoryImp();
    return _BaseContentSheet<HajjTravelData>(
      sheetTitle: _localizedTitle(
          en: 'Hajj Travel Documents',
          ur: 'حج سفری دستاویزات',
          ar: 'وثائق سفر الحج'),
      fetchData: () async {
        final result = await repo.getHajjTravelDocs();
        return result.fold(
              (l) => throw Exception(l.error),
              (r) => r.data?.isNotEmpty == true ? r.data!.first : null,
        );
      },
      getLocalizedContent: (data) => data.localizedContent,
    );
  }
}

// ─── Umrah Travel Sheet ───────────────────────────────────────────────────────

class UmrahTravelSheet extends StatelessWidget {
  const UmrahTravelSheet({super.key});

  static void show(BuildContext context) =>
      _showSheet(context, const UmrahTravelSheet());

  @override
  Widget build(BuildContext context) {
    final repo = UmrahTravelRepositoryImp();
    return _BaseContentSheet<UmrahTravelData>(
      sheetTitle: _localizedTitle(
          en: 'Umrah Travel Documents',
          ur: 'عمرہ سفری دستاویزات',
          ar: 'وثائق سفر العمرة'),
      fetchData: () async {
        final result = await repo.getUmrahTravelDocs();
        return result.fold(
              (l) => throw Exception(l.error),
              (r) => r.data?.isNotEmpty == true ? r.data!.first : null,
        );
      },
      getLocalizedContent: (data) => data.localizedContent,
    );
  }
}