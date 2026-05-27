import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import '../../../infrastructure/models/haram_gates.dart';
import '../../../infrastructure/services/json_loader_service.dart';
import '../../constants/asset_constant.dart';
import '../../elements/listTile.dart';
import '../../constants/app_strings.dart';

class HaramGatesScreen extends StatefulWidget {
  const HaramGatesScreen({super.key});

  @override
  State<HaramGatesScreen> createState() => _HaramGatesScreenState();
}

class _HaramGatesScreenState extends State<HaramGatesScreen> {
  List<HaramGateModel> _gates = [];
  bool _isLoading = true;

  static const TextStyle _arabicStyle = TextStyle(
    fontFamily: 'noto-sans',
    fontSize: 16,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await JsonLoaderService.loadHaramGates();
      setState(() {
        _gates = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading haram gates: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
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
                  title: AppStrings.haramGatesAppBarTitleTxt.tr,
                  icon: Icons.arrow_back,
                  color: FrontEndConfig.iconColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10),
                  child: Text(
                    AppStrings.haramGatesInfoHeadingTxt.tr,
                    style: FrontEndConfig.mainTextStyle,
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _gates.isEmpty
                      ? Center(
                    child: Text(
                      AppStrings.noResultsFoundTxt.tr,
                      style: FrontEndConfig.bodyTextStyle,
                    ),
                  )
                      : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    itemCount: _gates.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final gate = _gates[index];
                      return CommonListTile(
                        tileColor: FrontEndConfig.listTileColor,
                        borderGradient: FrontEndConfig.listTileBorder,
                        leading: CircleAvatar(
                          backgroundColor:
                          const Color(0xffC89C18).withOpacity(0.3),
                          radius: 18,
                          child: Text(
                            "${gate.gateNo}",
                            style: FrontEndConfig.headingTextStyle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        title: gate.localizedName,
                        subtitle: gate.arabicName,
                        subtitleStyle: _arabicStyle,
                        trailing: Transform.flip(
                          flipX: isRtl,
                          child: Image.asset(
                            AssetConstant.arrowDownIcon,
                            width: 10,
                            height: 10,
                          ),
                        ),
                        onTap: () => HaramGateBottomSheet.show(context, gate),
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

class HaramGateBottomSheet extends StatelessWidget {
  final HaramGateModel gate;

  const HaramGateBottomSheet({super.key, required this.gate});

  static void show(BuildContext context, HaramGateModel gate) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HaramGateBottomSheet(gate: gate),
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
                              "${gate.gateNo}",
                              style: FrontEndConfig.headingTextStyle.copyWith(
                                fontSize: 22,
                              ),
                            ),
                          ),
                          0.02.height(context),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: gate.localizedName,
                                  style: FrontEndConfig.mainTextStyle,
                                ),
                                // ✅ 5px spacing on both sides of the pipe
                                const WidgetSpan(
                                  child: SizedBox(width: 5),
                                ),
                                TextSpan(
                                  text: '|',
                                  style: FrontEndConfig.mainTextStyle,
                                ),
                                const WidgetSpan(
                                  child: SizedBox(width: 5),
                                ),
                                TextSpan(
                                  text: gate.arabicName,
                                  style: const TextStyle(
                                    fontFamily: 'noto-sans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          0.01.height(context),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                gate.localizedDescription,
                                textAlign: TextAlign.center,
                                style: FrontEndConfig.bodyTextStyle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
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
