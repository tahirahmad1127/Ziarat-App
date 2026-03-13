import 'package:flutter/material.dart';

class GradientOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;
  final double width;
  final double height;
  final Gradient gradient;
  final double borderWidth;

  const GradientOutlineButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.gradient,
    this.borderRadius = 30,
    this.width = double.infinity,
    this.height = 56,
    this.borderWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent,
        ),
        child: CustomPaint(
          painter: _GradientBorderPainter(
            borderRadius: borderRadius,
            strokeWidth: borderWidth,
            gradient: gradient,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientBorderPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(
        rect.deflate(strokeWidth / 2), Radius.circular(borderRadius));
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
