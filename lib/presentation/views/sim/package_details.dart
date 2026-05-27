import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/infrastructure/models/packages.dart';
import 'package:ziarat_app/infrastructure/models/sim_provider.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';

class PackageDetails extends StatelessWidget {
  final SimProviderModel provider;
  final List<PackageModel> packages;

  const PackageDetails({super.key, required this.provider, required this.packages});

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
                CommonAppBar(
                  title: provider.title ?? "Package Details", // ✅ real provider title
                  icon: Icons.arrow_back,
                  color: FrontEndConfig.iconColor,
                  onLeadingTap: () => NavigatorHelper.pop(context),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: packages.length, // ✅ real count
                    itemBuilder: (BuildContext context, int index) {
                      final package = packages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
                        child: MyContainer(
                          height: 165,
                          decoration: BoxDecoration(
                            gradient: FrontEndConfig.btnBorderColor,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: MyContainer(
                              decoration: BoxDecoration(
                                color: FrontEndConfig.listTileColor,
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 65,
                                    child: ListTile(
                                      title: Text(
                                        package.packageName ?? '', // ✅ Fixed: was packageTitle
                                        style: FrontEndConfig.packageTextStyle,
                                      ),
                                      subtitle: Text(
                                        package.duration ?? '', // ✅ real duration
                                        style: FrontEndConfig.subHeadingTextStyle,
                                      ),
                                      trailing: Text(
                                        "${package.price ?? 0} ${package.currency ?? 'SAR'}", // ✅ Fixed: was amount
                                        style: FrontEndConfig.packageTextStyle,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Divider(height: 1, color: const Color(0xffD2D2D2), thickness: 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(AssetConstant.signal, width: 20, height: 20, color: FrontEndConfig.iconColor),
                                            0.005.height(context),
                                            Text(AppStrings.gbsLabelTxt.tr, style: FrontEndConfig.packageDetailTextStyle.copyWith(color: const Color(0xffD2D2D2))),
                                            Text("${package.dataGB ?? 0} GB", style: FrontEndConfig.packageTextStyle), // ✅ Fixed: was gbs
                                          ],
                                        ),
                                        _buildDividerLinear(),
                                        Column(
                                          children: [
                                            Image.asset(AssetConstant.phone, width: 20, height: 20),
                                            0.005.height(context),
                                            Text(AppStrings.onNetMinutesLabelTxt.tr, style: FrontEndConfig.packageDetailTextStyle),
                                            Text("${package.onNetMinutes ?? 0}", style: FrontEndConfig.packageTextStyle), // ✅ real minutes
                                          ],
                                        ),
                                        _buildDividerLinear(),
                                        Column(
                                          children: [
                                            Image.asset(AssetConstant.phoneCall, width: 20, height: 20),
                                            0.005.height(context),
                                            Text(AppStrings.internationalMinutesLabelTxt.tr, style: FrontEndConfig.packageDetailTextStyle),
                                            Text("${package.internationalMinutes ?? 0}", style: FrontEndConfig.packageTextStyle), // ✅ Fixed: was interMinutes
                                          ],
                                        ),
                                        _buildDividerLinear(),
                                        Column(
                                          children: [
                                            Image.asset(AssetConstant.message, width: 20, height: 20),
                                            0.005.height(context),
                                            Text(AppStrings.smsLabelTxt.tr, style: FrontEndConfig.packageDetailTextStyle),
                                            Text("${package.sms ?? 0}", style: FrontEndConfig.packageTextStyle), // ✅ real SMS
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDividerLinear() {
    return Container(
      height: 44,
      width: 0.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff999999), Color(0xffFFFFFF), Color(0xff999999)],
        ),
      ),
    );
  }
}