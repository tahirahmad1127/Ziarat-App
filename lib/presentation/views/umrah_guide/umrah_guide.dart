import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/application/navigation_helper.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import 'package:ziarat_app/presentation/views/umrah_guide/method_putting_ihram.dart';

import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../elements/listTile.dart';
import '../../constants/app_strings.dart';

class UmrahGuide extends StatefulWidget {
  const UmrahGuide({super.key});

  @override
  State<UmrahGuide> createState() => _UmrahGuideState();
}

class _UmrahGuideState extends State<UmrahGuide> {
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
                  title: AppStrings.umrahGuideAppBarTitleTxt.tr,
                  color: FrontEndConfig.iconColor,
                  showLeading: false,
                ),
                0.02.height(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.prepareBeforeUmrahHeadingTxt.tr,
                          style: FrontEndConfig.mainTextStyle.copyWith(fontSize: 18),
                        ),
                        0.02.height(context),

                        CommonListTile(
                          tileColor: FrontEndConfig.listTileColor,
                          borderGradient: FrontEndConfig.listTileBorder,
                          image: AssetConstant.documentIcon,
                          title: AppStrings.checkTravelDocumentsTxt.tr,
                          trailing: Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
                          onTap: () => TravelDocumentsSheet.show(context),
                        ),
                        0.02.height(context),

                        CommonListTile(
                          tileColor: FrontEndConfig.listTileColor,
                          borderGradient: FrontEndConfig.listTileBorder,
                          image: AssetConstant.packIcon,
                          title: AppStrings.packSmartlyTxt.tr,
                          trailing: Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
                          onTap: () {},
                        ),
                        0.02.height(context),

                        CommonListTile(
                          tileColor: FrontEndConfig.listTileColor,
                          borderGradient: FrontEndConfig.listTileBorder,
                          image: AssetConstant.bagListIcon,
                          title: AppStrings.checkUmrahPackageDetailsTxt.tr,
                          trailing: Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
                          onTap: () {},
                        ),
                        0.02.height(context),

                        CommonListTile(
                          tileColor: FrontEndConfig.listTileColor,
                          borderGradient: FrontEndConfig.listTileBorder,
                          image: AssetConstant.aeroplaneIcon,
                          title: AppStrings.checkTravelDocumentsTxt.tr,
                          trailing: Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
                          onTap: () {},
                        ),
                        0.02.height(context),

                        Text(
                          AppStrings.howToPerformUmrahHeadingTxt.tr,
                          style: FrontEndConfig.mainTextStyle.copyWith(fontSize: 18),
                        ),
                        0.02.height(context),

                        CommonListTile(
                          tileColor: FrontEndConfig.listTileColor,
                          borderGradient: FrontEndConfig.listTileBorder,
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xffC89C18).withOpacity(0.3),
                            radius: 13,
                            child: Text(
                              "1",
                              style: GoogleFonts.raleway(
                                color: FrontEndConfig.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          title: AppStrings.methodOfPuttingIhramTxt.tr,
                          onTap: () {
                            NavigatorHelper.push(context, MethodPuttingIhram());
                          },
                        ),
                        0.02.height(context),

                        CommonListTile(
                          tileColor: FrontEndConfig.listTileColor,
                          borderGradient: FrontEndConfig.listTileBorder,
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xffC89C18).withOpacity(0.3),
                            radius: 13,
                            child: Text(
                              "2",
                              style: GoogleFonts.raleway(
                                color: FrontEndConfig.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          title: AppStrings.methodOfPuttingIhramTxt.tr,
                          onTap: () {},
                        ),
                      ],
                    ),
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



class TravelDocumentsSheet extends StatelessWidget {
  const TravelDocumentsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TravelDocumentsSheet(),
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
                  /// Background Image
                  Positioned.fill(
                    child: Image.asset(
                      AssetConstant.bottomSheetDesgin,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// Content
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                      ),
                      child: Column(
                        children: [
                          /// Handle bar
                          Container(
                            width: 89,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          0.02.height(context),

                          /// Icon
                          CircleAvatar(
                            radius: 25,
                            backgroundColor:
                            const Color(0xffC89C18).withOpacity(0.3),
                            child: Image.asset(
                              AssetConstant.documentIcon,
                              width: 24,
                              height: 24,
                            ),
                          ),

                          0.02.height(context),

                          /// Title
                          Text(
                            AppStrings.checkTravelDocumentsTitleTxt.tr,
                            style: FrontEndConfig.mainTextStyle,
                          ),

                          0.01.height(context),

                          /// Items
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Text(AppStrings.travelDocPassportValidityTxt.tr,
                                    style: FrontEndConfig.bodyTextStyle),
                                const SizedBox(height: 12),
                                Text(AppStrings.travelDocVisaRequirementsTxt.tr,
                                    style: FrontEndConfig.bodyTextStyle),
                                const SizedBox(height: 12),
                                Text(AppStrings.travelDocFlightDetailsTxt.tr,
                                    style: FrontEndConfig.bodyTextStyle),
                                const SizedBox(height: 12),
                                Text(AppStrings.travelDocHotelBookingTxt.tr,
                                    style: FrontEndConfig.bodyTextStyle),
                              ],
                            ),
                          ),

                          /// Close
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextButton(
                              onPressed: () => NavigatorHelper.pop(context),
                              child: Text(
                                AppStrings.closeBottomSheetBtnTxt.tr,
                                style:
                                FrontEndConfig.headingTextStyle.copyWith(
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