import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import '../../../infrastructure/models/terms_condition.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';

class TermAndConditions extends StatelessWidget {
  final TermsConditionsModel termsConditions;

  const TermAndConditions({super.key, required this.termsConditions});

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
                  title: termsConditions.data?.title ?? AppStrings.termsAndConditionsScreenTxt.tr,
                  icon: Icons.arrow_back,
                  color: FrontEndConfig.iconColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 11),
                    child: SingleChildScrollView(
                      child: Text(
                        termsConditions.data?.content ?? "",
                        style: FrontEndConfig.bodyTextStyle,
                      ),
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