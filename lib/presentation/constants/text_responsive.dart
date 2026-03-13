import 'package:flutter/material.dart';

extension ResponsiveText on BuildContext {

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  /// Responsive font scaling
  double responsiveFont(double size) {
    double baseWidth = 375; // Standard mobile width
    return (screenWidth / baseWidth) * size;
  }
}