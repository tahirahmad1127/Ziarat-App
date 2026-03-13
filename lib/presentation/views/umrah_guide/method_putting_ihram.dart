import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';

import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../elements/app_bar.dart';
import '../../constants/app_strings.dart';

class MethodPuttingIhram extends StatelessWidget {
  const MethodPuttingIhram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Color
          Container(
            color: FrontEndConfig.backgroundColor,
          ),

          /// Background Image
          Positioned.fill(
            child: Image.asset(
              AssetConstant.backgroundimage,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            CommonAppBar(
              title: AppStrings.umrahGuideAppBarTitleTxt.tr,
              color: FrontEndConfig.iconColor,
              icon: Icons.arrow_back,
            ),
            0.02.height(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(AppStrings.methodOfPuttingIhramTxt.tr, style: FrontEndConfig.mainTextStyle,),

                0.02.height(context),
                Text(AppStrings.methodOfPuttingIhramDescriptionTxt.tr,
                  style: FrontEndConfig.bodyTextStyle,)
              ],),
            )

          ],))
        ],
      ),
    );
  }
}
