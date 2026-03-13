import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';

import '../../../infrastructure/models/privacy_policy.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';
class PrivacyPolicy extends StatelessWidget {
  final PrivacyPolicyModel privacyPolicy;

  const PrivacyPolicy({super.key, required this.privacyPolicy});

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
                  title: privacyPolicy.data?.title ?? AppStrings.privacyPolicyScreenTxt.tr,
                  icon: Icons.arrow_back,
                  color: FrontEndConfig.iconColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 11),
                    child: SingleChildScrollView(
                      child: Text(
                        privacyPolicy.data?.content ?? "",
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