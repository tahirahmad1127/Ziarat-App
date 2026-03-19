import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/constants/asset_constant.dart';

class CommonAppBar extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color? color;
  final String? actionIcon;
  final VoidCallback? onActionTap;
  final VoidCallback? onLeadingTap;
  final bool showLeading;
  final double actionIconSize;

  const CommonAppBar({
    super.key,
    this.title,
    this.icon,
    this.color,
    this.actionIcon,
    this.onActionTap,
    this.onLeadingTap,
    this.showLeading = true,
    this.actionIconSize = 24,
  });

  String _getFontFamily() {
    final locale = Get.locale?.languageCode;
    if (locale == 'ar') return 'noto-sans';
    if (locale == 'ur') return 'jameel-noori';
    return 'Raleway';
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    final IconData? leadingIcon = icon ??
        (Navigator.canPop(context)
            ? (isRtl ? Icons.arrow_back : Icons.arrow_forward)
            : null);

    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: showLeading
          ? GestureDetector(
        onTap: onLeadingTap ??
            (Navigator.canPop(context)
                ? () => Navigator.pop(context)
                : null),
        child: Icon(
          leadingIcon,
          color: FrontEndConfig.iconColor,
        ),
      )
          : null,
      actions: [
        if (actionIcon != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: onActionTap,
              child: Image.asset(
                actionIcon!,
                color: FrontEndConfig.iconColor,
                width: actionIconSize,
                height: actionIconSize,
              ),
            ),
          ),
      ],
      centerTitle: true,
      title: Text(
        title.toString(),
        style: TextStyle(
          fontFamily: _getFontFamily(),
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: FrontEndConfig.appBarTitleColor,
        ),
      ),
    );
  }
}