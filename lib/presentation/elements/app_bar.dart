import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  const CommonAppBar({
    super.key,
    this.title,
    this.icon,
    this.color,
    this.actionIcon,
    this.onActionTap,
    this.onLeadingTap,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: showLeading
          ? GestureDetector(
        onTap: onLeadingTap ?? (Navigator.canPop(context) ? () => Navigator.pop(context) : null),
        child: Icon(
          icon ?? (Navigator.canPop(context) ? Icons.arrow_back_ios : null),
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
                width: 24,
                height: 24,
              ),
            ),
          ),
      ],
      centerTitle: true,
      title: Text(
        title.toString(),
        style: GoogleFonts.raleway(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: FrontEndConfig.appBarTitleColor,
        ),
      ),
    );
  }
}