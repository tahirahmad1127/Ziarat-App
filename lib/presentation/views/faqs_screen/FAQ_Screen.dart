import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/application/navigation_helper.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import '../../../infrastructure/models/haram_gates.dart';
import '../../../infrastructure/models/umrah_masail.dart';
import '../../../infrastructure/services/json_loader_service.dart';
import '../../constants/asset_constant.dart';
import '../../elements/listTile.dart';
import '../../constants/app_strings.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<UmrahMasailModel> _faqs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await JsonLoaderService.loadUmrahMasail();
      setState(() {
        _faqs = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),
          Positioned.fill(
            child: Image.asset(AssetConstant.backgroundimage, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonAppBar(
                  title: AppStrings.faqAppBarTitleTxt.tr,
                  icon: Icons.arrow_back,
                  color: FrontEndConfig.iconColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10),
                  child: Text(
                    AppStrings.faqIntroTxt.tr,
                    style: FrontEndConfig.bodyTextStyle,
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    itemCount: _faqs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final faq = _faqs[index];
                      return CommonListTile(
                        tileColor: FrontEndConfig.listTileColor,
                        borderGradient: FrontEndConfig.listTileBorder,
                        leading: CircleAvatar(
                          backgroundColor:
                          const Color(0xffC89C18).withOpacity(0.3),
                          radius: 13,
                          child: Text(
                            "${index + 1}",
                            style: GoogleFonts.raleway(
                              color: FrontEndConfig.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        title: faq.localizedQuestion,  // ✅ localized
                        trailing: Image.asset(
                          AssetConstant.arrowDownIcon,
                          width: 10,
                          height: 10,
                        ),
                        onTap: () => FaqBottomSheet.show(context, index + 1, faq),
                      );
                    },
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

class FaqBottomSheet extends StatelessWidget {
  final int number;
  final UmrahMasailModel faq;  // ✅ changed from FaqData to UmrahMasailModel

  const FaqBottomSheet({super.key, required this.number, required this.faq});

  static void show(BuildContext context, int number, UmrahMasailModel faq) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FaqBottomSheet(number: number, faq: faq),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.40,
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
                  Positioned.fill(
                    child: Image.asset(
                      AssetConstant.bottomSheetDesgin,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Column(
                        children: [
                          Container(
                            width: 89,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          0.02.height(context),
                          CircleAvatar(
                            backgroundColor:
                            const Color(0xffC89C18).withOpacity(0.3),
                            radius: 28,
                            child: Text(
                              "$number",
                              style: GoogleFonts.raleway(
                                color: FrontEndConfig.textColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          0.02.height(context),
                          Text(
                            faq.localizedQuestion,  // ✅ localized
                            textAlign: TextAlign.center,
                            style: FrontEndConfig.mainTextStyle,
                          ),
                          0.01.height(context),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                faq.localizedAnswer,  // ✅ localized
                                textAlign: TextAlign.center,
                                style: FrontEndConfig.bodyTextStyle,
                              ),
                            ),
                          ),
                          TextButton(
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
                        ],
                      ),
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