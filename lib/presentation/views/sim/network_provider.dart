import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/application/navigation_helper.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import 'package:ziarat_app/presentation/views/sim/package_details.dart';
import '../../../application/sim_provider_bloc/sim_provider_bloc.dart';
import '../../../infrastructure/models/sim_provider.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';
import 'layout/package_details_body.dart';

class NetworkProvider extends StatelessWidget {
  final List<SimProviderModel> providers;

  const NetworkProvider({super.key, required this.providers});

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
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CommonAppBar(
                    title: AppStrings.networkProvidersAppBarTitleTxt.tr,
                    actionIcon: AssetConstant.helpIcon,
                    icon: Icons.arrow_back,
                    onActionTap: () => _buildShowInfoSheet(context),
                  ),
                ),
                0.02.height(context),

                // SIM Info Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MyContainer(
                    decoration: BoxDecoration(
                      gradient: FrontEndConfig.btnBorderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: MyContainer(
                        decoration: BoxDecoration(
                          color: FrontEndConfig.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 230,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                AssetConstant.sim,
                                fit: BoxFit.cover,
                                height: 230,
                              ),
                            ),
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0xff354A64).withOpacity(0.3),
                                    Color(0xff354A64).withOpacity(0.5),
                                    Color(0xff354A64),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(AppStrings.simInfoHeadingTxt.tr, style: FrontEndConfig.languageHeadingTextStyle),
                                  0.01.height(context),
                                  Text(
                                    AppStrings.simInfoDescriptionTxt.tr,
                                    textAlign: TextAlign.center,
                                    style: FrontEndConfig.bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
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
                0.02.height(context),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppStrings.listOfProvidersHeadingTxt.tr, style: FrontEndConfig.mainTextStyle),
                  ),
                ),
                0.01.height(context),

                // Provider List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      itemCount: providers.length,
                      itemBuilder: (BuildContext context, int index) {
                        final provider = providers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: MyContainer(
                            height: 85,
                            decoration: BoxDecoration(
                              gradient: FrontEndConfig.btnBorderColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: MyContainer(
                                onTap: () {
                                  NavigatorHelper.push(
                                    context,
                                    PackageDetailsViewBody(provider: provider), // ✅ pass provider
                                  );
                                },
                                decoration: BoxDecoration(
                                  color: FrontEndConfig.backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          provider.image ?? '',          // ✅ real image from API
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Image.asset(
                                            AssetConstant.sim1,
                                            width: 60,
                                            height: 60,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            provider.title ?? '',         // ✅ real title
                                            style: FrontEndConfig.headingTextStyle,
                                          ),
                                          Row(
                                            children: [
                                              Text(AppStrings.helplineLabelTxt.tr, style: FrontEndConfig.headingTextStyle),
                                              0.01.width(context),
                                              Text(
                                                provider.helplineNumber ?? '', // ✅ real helpline
                                                style: FrontEndConfig.subHeadingTextStyle,
                                              ),
                                              0.2.width(context),
                                              Image.asset(AssetConstant.arrowForwardIcon, width: 20, height: 20),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(AssetConstant.signal, width: 16, height: 16, color: Colors.green),
                                              0.01.width(context),
                                              Text(
                                                provider.description ?? '', // ✅ real description
                                                style: FrontEndConfig.subHeadingTextStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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

  Future<dynamic> _buildShowInfoSheet(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
            child: MyContainer(
              decoration: BoxDecoration(
                gradient: FrontEndConfig.btnBorderColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: MyContainer(
                  height: MediaQuery.of(context).size.height * 0.43,
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
                          child: Image.asset(AssetConstant.bottomSheetDesgin, fit: BoxFit.cover),
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
                                  radius: 30,
                                  backgroundColor: Color(0xffC89C18).withOpacity(0.3),
                                  backgroundImage: AssetImage(AssetConstant.ellipseIcon),
                                  child: Image.asset(AssetConstant.announcement, width: 34, height: 34),
                                ),
                                0.02.height(context),
                                Text(AppStrings.requirementsForSimHeadingTxt.tr, style: FrontEndConfig.mainTextStyle),
                                0.02.height(context),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      Text(AppStrings.requirementPassportValidityTxt.tr, style: FrontEndConfig.bodyTextStyle),
                                      const SizedBox(height: 12),
                                      Text(AppStrings.requirementFingerprintVerificationTxt.tr, style: FrontEndConfig.bodyTextStyle),
                                      const SizedBox(height: 12),
                                      Text(AppStrings.requirementUsuallyActiveTxt.tr, style: FrontEndConfig.bodyTextStyle),
                                      const SizedBox(height: 12),
                                      Text(AppStrings.requirementGetSimsJeddahTxt.tr, style: FrontEndConfig.bodyTextStyle),
                                    ],
                                  ),
                                ),
                                0.01.height(context),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
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
          ),
        );
      },
    );
  }
}