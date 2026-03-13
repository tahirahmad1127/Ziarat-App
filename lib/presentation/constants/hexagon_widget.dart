import 'package:flutter/material.dart';

class HexagonContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final Gradient? gradient;
  final Color? color;
  final double borderWidth;
  final Color? borderColor;

  const HexagonContainer({
    super.key,
    required this.width,
    required this.height,
    this.child,
    this.gradient,
    this.color,
    this.borderWidth = 0,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HexagonClipper(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          gradient: gradient,
          border: borderWidth > 0
              ? Border.all(color: borderColor ?? Colors.black, width: borderWidth)
              : null,
        ),
        child: child,
      ),
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final side = w / 2;
    final heightOffset = (h - side) / 2;

    path.moveTo(w * 0.25, 0); // top-left
    path.lineTo(w * 0.75, 0); // top-right
    path.lineTo(w, h / 2);    // right-middle
    path.lineTo(w * 0.75, h); // bottom-right
    path.lineTo(w * 0.25, h); // bottom-left
    path.lineTo(0, h / 2);    // left-middle
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}