import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';

import '../constants/asset_constant.dart';

class CommonListTile extends StatelessWidget {
  final Color? tileColor;
  final LinearGradient? borderGradient;
  final String? image;
  final String? title;
  final String? subtitle;
  final String? subtitle1;
  final TextStyle? subtitleStyle; // ✅ added
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
    this.subtitleStyle, // ✅ added
    this.icon,
    this.title,
    this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
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
          leading: leading ??
              (image != null
                  ? Image.asset(
                image!,
                width: 24,
                height: 24,
                color: FrontEndConfig.listTileIconColor,
                fit: BoxFit.contain,
              )
                  : null),
          title: Text(
            title ?? "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: FrontEndConfig.listTileTextColor,
              fontFamily: GoogleFonts.raleway().fontFamily,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
            subtitle!,
            style: subtitleStyle ?? // ✅ use custom style if provided
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: FrontEndConfig.listTileTextColor,
                  fontFamily: GoogleFonts.raleway().fontFamily,
                ),
          )
              : null,
          trailing: trailing ??
              Image.asset(
                AssetConstant.arrowForwardIcon,
                width: 24,
                height: 24,
              ),
        ),
      ),
    );
  }
}