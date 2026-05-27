import 'package:flutter/material.dart';

import '../../configurations/frontend_config.dart';

class LanguageTile extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final Color? tileColor;
  final LinearGradient? borderGradient;
  final IconData? icon;
  final VoidCallback? onTap;

  const LanguageTile({
    super.key,
    this.title,
    this.subtitle,
    this.tileColor,
    this.borderGradient,
    this.icon,
    this.onTap,
  });

  @override
  State<LanguageTile> createState() => _LanguageTileState();
}

class _LanguageTileState extends State<LanguageTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(1.5), // Border thickness
        decoration: BoxDecoration(
          gradient: widget.borderGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          height: 94,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: widget.tileColor ??
                FrontEndConfig.listTileColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Title & Subtitle
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title ?? "",
                    style: FrontEndConfig.mainTextStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle ?? "",
                    style: FrontEndConfig.arabicTextStyle,
                  ),
                ],
              ),

              /// Trailing Icon
              ShaderMask(
                shaderCallback: (bounds) {
                  final gradient =
                      widget.borderGradient ?? FrontEndConfig.listTileBorder;

                  return gradient.createShader(bounds);
                },
                child: Icon(
                  widget.icon ?? Icons.circle_outlined,
                  size: 28,
                  color: Colors.white, // Must stay white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}