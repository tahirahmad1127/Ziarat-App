import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziarat_app/infrastructure/models/ziarat_details.dart';
import 'package:ziarat_app/presentation/views/bottom_bar/bottom_bar.dart';
import 'package:ziarat_app/presentation/views/onBoarding/onBoarding_page.dart';
import 'package:ziarat_app/presentation/views/ziarat_details/ziarat_details.dart';

import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import '../../../infrastructure/models/maintenance.dart';
import '../../../infrastructure/services/maintenance.dart';
import '../../../main.dart'; // pendingNotificationPayload, splashCompleted
import '../../constants/asset_constant.dart';
import '../maintenence/maintenence_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _firstLaunchKey = 'is_first_launch';

  final MaintenanceService _maintenanceService = MaintenanceService();

  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  // ─── Build ZiaratDetails from a notification payload and push it ──────────
  //
  // Called from three places:
  //   1. Terminated-state: pendingNotificationPayload set by onActionReceivedMethod
  //   2. Background → foreground: FirebaseMessaging.onMessageOpenedApp
  //   3. Foreground: the SnackBar "View" action
  //
  // Expected payload keys (all String — FCM & AwesomeNotifications send strings):
  //   id          → Data.id            (required — skip if missing / empty)
  //   type        → Data.type
  //   title       → Data.title
  //   description → Data.description
  //   dua         → Data.dua
  //   lat         → Data.lat           (double serialised as string)
  //   lng         → Data.lng
  //   image       → Data.images[0]     (single URL)
  //   audioGuide  → Data.audioGuide

  void _handleNotificationTap(Map<String, String?> payload) {
    log('📲 [ZIARAT] Routing to ZiaratDetails from payload: $payload');

    final ziaratId = payload['id'];
    if (ziaratId == null || ziaratId.isEmpty) {
      log('⚠️ [ZIARAT] No id in payload — skipping deep link');
      return;
    }

    final imageUrl = payload['image'];
    final data = Data(
      id: ziaratId,
      type: payload['type'],
      duaRaw: payload['dua'],
      lat: double.tryParse(payload['lat'] ?? ''),
      lng: double.tryParse(payload['lng'] ?? ''),
      images: (imageUrl != null && imageUrl.isNotEmpty) ? [imageUrl] : [],
      titleMap: payload['title'] != null ? {'en': payload['title']!} : {},
      descriptionMap: payload['description'] != null ? {'en': payload['description']!} : {},
      audioGuideMap: payload['audioGuide'] != null ? {'en': payload['audioGuide']!} : {},
      isActive: true,
    );

    NavigatorHelper.push(context, ZiaratDetails(data: data));
  }

  // ─── Main navigation flow ─────────────────────────────────────────────────

  Future<void> _handleNavigation() async {
    // Run the minimum splash delay and maintenance check in parallel.
    final futures = await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      _maintenanceService.getMaintenanceStatus(),
    ]);

    if (!mounted) return;

    final maintenance = futures[1] as MaintenanceModel;

    if (maintenance.isEnabled) {
      NavigatorHelper.pushReplacement(context, const MaintenanceScreen());
      return;
    }

    // ── Determine base screen ───────────────────────────────────────────────
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;

    if (!mounted) return;

    if (isFirstLaunch) {
      await prefs.setBool(_firstLaunchKey, false);
      // Mark splash done and discard any notification payload — user hasn't
      // completed onboarding yet so we don't deep-link into content.
      splashCompleted = true;
      pendingNotificationPayload = null;
      NavigatorHelper.pushReplacement(context, const OnboardingPage());
      return;
    }

    // ── Push BottomBarScreen as the navigation stack base ──────────────────
    NavigatorHelper.pushReplacement(context, const BottomBarScreen());

    // Mark splash complete so future taps from onActionReceivedMethod route
    // directly instead of storing in pendingNotificationPayload.
    splashCompleted = true;

    // ── Terminated-state: AwesomeNotifications tap ─────────────────────────
    // onActionReceivedMethod (main.dart) fires before the navigator is ready
    // and stores the payload here. We pick it up now that BottomBarScreen is
    // the active route so ZiaratDetails lands on top of it (back → home feed).
    final awesomePayload = pendingNotificationPayload;
    if (awesomePayload != null && awesomePayload.isNotEmpty) {
      pendingNotificationPayload = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final safePayload = Map<String, String>.fromEntries(
          awesomePayload.entries
              .where((e) => e.value != null)
              .map((e) => MapEntry(e.key, e.value!)),
        );
        log('📲 [ZIARAT] Picking up pending AwesomeNotification payload');
        _handleNotificationTap(safePayload);
      });
      // Skip the FCM getInitialMessage check — we already have the payload.
      _startLiveListeners();
      return;
    }

    // ── Terminated-state: FCM system notification tap ──────────────────────
    // This fires only when the FCM message included a 'notification' block
    // (which causes FCM itself to show a system tray notification).
    // For data-only topic broadcasts the AwesomeNotifications path above
    // handles routing. This is a safety net for notification-block messages.
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (!mounted) return;

    if (initialMessage != null && initialMessage.data.isNotEmpty) {
      log('📩 [ZIARAT] FCM terminated-state tap: ${initialMessage.messageId}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final safePayload = initialMessage.data.map(
              (k, v) => MapEntry(k, v.toString()),
        );
        _handleNotificationTap(safePayload);
      });
    }

    _startLiveListeners();
  }

  // ─── Live FCM listeners (background→foreground + foreground) ─────────────
  // Called once BottomBarScreen is the active route so the navigator context
  // is always valid when we push ZiaratDetails.

  void _startLiveListeners() {
    // Background → foreground tap (FCM system notification with 'notification'
    // block). Data-only broadcasts are handled by onActionReceivedMethod.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('🔔 [ZIARAT] onMessageOpenedApp: ${message.data}');
      if (message.data.isNotEmpty && mounted) {
        _handleNotificationTap(
          message.data.map((k, v) => MapEntry(k, v.toString())),
        );
      }
    });

    // Foreground: show a SnackBar with a "View" action.
    // AwesomeNotifications already shows a heads-up banner in the foreground
    // (created in MyApp._setupForegroundFCM), so the SnackBar is optional —
    // remove it if you prefer only the banner.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('📩 [ZIARAT] Foreground FCM: ${message.data}');
      final notification = message.notification;
      if (notification != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              notification.title ?? notification.body ?? 'New Ziarat Update',
            ),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                if (message.data.isNotEmpty) {
                  _handleNotificationTap(
                    message.data.map((k, v) => MapEntry(k, v.toString())),
                  );
                }
              },
            ),
          ),
        );
      }
    });
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background colour
          Container(color: FrontEndConfig.backgroundColor),

          // Background image
          Positioned.fill(
            child: Image.asset(
              AssetConstant.backgroundimage,
              fit: BoxFit.cover,
            ),
          ),

          // Centre logo
          Center(
            child: Image.asset(
              AssetConstant.splashlogo,
              height: 353,
              width: 353,
            ),
          ),
        ],
      ),
    );
  }
}