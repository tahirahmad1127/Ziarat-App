import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';

import '../constants/asset_constant.dart';

class CommonListTile extends StatelessWidget {
  final Color? tileColor;
  final LinearGradient? borderGradient;
  final String? image;
  final String? title;
  final String? subtitle;
  final String? subtitle1;
  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;
  final IconData? icon;
  final Widget? trailing;
  final Widget? leading;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  const CommonListTile({
    super.key,
    this.tileColor,
    this.borderGradient,
    this.image,
    this.trailing,
    this.leading,
    this.subtitle,
    this.subtitle1,
    this.subtitleStyle,
    this.titleStyle,
    this.icon,
    this.title,
    this.onTap,
    this.height,
    this.width,
  });

  /// Helper method to get appropriate font family based on locale
  String _getFontFamily() {
    final locale = Get.locale?.languageCode;
    if (locale == 'ar') {
      return 'noto-sans';
    } else if (locale == 'ur') {
      return 'jameel-noori';
    }
    return 'Raleway';
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        gradient: borderGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: tileColor ?? FrontEndConfig.listTileColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: ListTile(
          onTap: onTap,

          // Leading icon — flip horizontally in RTL
          leading: leading ??
              (image != null
                  ? Transform.scale(
                scaleX: isRtl ? -1 : 1,
                child: Image.asset(
                  image!,
                  width: 24,
                  height: 24,
                  color: FrontEndConfig.listTileIconColor,
                  fit: BoxFit.contain,
                ),
              )
                  : null),

          title: Text(
            title ?? "",
            style: titleStyle ??
                TextStyle(
                  fontSize: FrontEndConfig.fontSize(16),
                  fontWeight: FontWeight.w600,
                  color: FrontEndConfig.listTileTextColor,
                  fontFamily: _getFontFamily(),
                ),
          ),

          subtitle: subtitle != null
              ? Text(
            subtitle!,
            style: subtitleStyle ??
                TextStyle(
                  fontSize: FrontEndConfig.fontSize(12),
                  fontWeight: FontWeight.w400,
                  color: FrontEndConfig.listTileTextColor,
                  fontFamily: _getFontFamily(),
                ),
          )
              : null,

          // Trailing — if a custom widget is passed use it as-is,
          // otherwise render the default arrow flipped in RTL
          trailing: trailing ??
              Transform.scale(
                scaleX: isRtl ? -1 : 1,
                child: Image.asset(
                  AssetConstant.arrowForwardIcon,
                  width: 24,
                  height: 24,
                ),
              ),
        ),
      ),
    );
  }
}