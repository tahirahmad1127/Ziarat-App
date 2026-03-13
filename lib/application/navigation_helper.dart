import 'package:flutter/material.dart';

enum NavigationAnimation {
  slide,
  fade,
  scale,
  slideUp,
  slideDown,
  rotation,
}

class NavigatorHelper {
  static const Duration _defaultDuration = Duration(milliseconds: 300);

  /// Push a new page with animation
  static Future<T?> push<T extends Object?>(
      BuildContext context,
      Widget page, {
        NavigationAnimation animation = NavigationAnimation.fade,
        Duration duration = _defaultDuration,
      }) {
    return Navigator.push(
      context,
      _buildPageRoute(page, animation, duration),
    );
  }

  /// Push replacement with animation
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      BuildContext context,
      Widget page, {
        TO? result,
        NavigationAnimation animation = NavigationAnimation.fade,
        Duration duration = _defaultDuration,
      }) {
    return Navigator.pushReplacement(
      context,
      _buildPageRoute(page, animation, duration),
      result: result,
    );
  }

  /// Push and remove until with animation
  static Future<T?> pushAndRemoveUntil<T extends Object?>(
      BuildContext context,
      Widget page, {
        bool removeAll = true,
        NavigationAnimation animation = NavigationAnimation.fade,
        Duration duration = _defaultDuration,
      }) {
    return Navigator.pushAndRemoveUntil(
      context,
      _buildPageRoute(page, animation, duration),
          (route) => removeAll ? false : true,
    );
  }

  /// Pop current screen
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Build page route with specified animation
  static PageRoute<T> _buildPageRoute<T>(
      Widget page,
      NavigationAnimation animation,
      Duration duration,
      ) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, anim, secondaryAnim, child) {
        return _buildTransition(animation, anim, secondaryAnim, child);
      },
    );
  }

  /// Build the transition animation
  static Widget _buildTransition(
      NavigationAnimation animationType,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );

    switch (animationType) {
      case NavigationAnimation.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case NavigationAnimation.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case NavigationAnimation.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: child,
        );

      case NavigationAnimation.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case NavigationAnimation.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case NavigationAnimation.rotation:
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
    }
  }

  /// Quick access methods for common animations
  static Future<T?> pushFade<T extends Object?>(BuildContext context, Widget page,) {
    return push(context, page, animation: NavigationAnimation.fade);
  }

  static Future<T?> pushScale<T extends Object?>(BuildContext context, Widget page,) {
    return push(context, page, animation: NavigationAnimation.scale);
  }

  static Future<T?> pushSlideUp<T extends Object?>(BuildContext context, Widget page,) {
    return push(context, page, animation: NavigationAnimation.slideUp);
  }
}