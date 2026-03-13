import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final BorderSide? borderSide;
  final LinearGradient? gradient;
  final List<BoxShadow>? boxShadow;
  final BoxConstraints? constraints;
  final GestureTapCallback? onTap;

  const MyContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.alignment,
    this.width,
    this.height,
    this.decoration,
    this.color,
    this.borderRadius,
    this.border,
    this.gradient,
    this.boxShadow,
    this.constraints,
    this.onTap, this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
          gradient: gradient,
          boxShadow: boxShadow,

        );

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      constraints: constraints,
      decoration: effectiveDecoration,
      child: child,
    );

    // Wrap with GestureDetector only if onTap is provided
    if (onTap != null) {
      container = GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}
