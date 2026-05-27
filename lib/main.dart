import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ziarat_app/presentation/constants/app_strings.dart';
import 'package:ziarat_app/presentation/localization/app_translations.dart';
import 'package:ziarat_app/presentation/views/splash_screen/splash_screen.dart';
import 'package:ziarat_app/presentation/views/ziarat_details/ziarat_details.dart';
import 'application/counter_bloc/counter_bloc.dart';
import 'firebase_options.dart';
import 'infrastructure/models/ziarat_details.dart';
import 'infrastructure/services/localization.dart';
import 'injection_container.dart' as di;

// ─── NAVIGATOR KEY ────────────────────────────────────────────────────────────
// A global navigator key so onActionReceivedMethod (which runs outside the
// widget tree) can push routes after the app is fully initialised.

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ─── PENDING NOTIFICATION PAYLOAD ────────────────────────────────────────────
// When the app cold-starts from a notification tap, onActionReceivedMethod
// fires before SplashScreen has finished navigating to BottomBarScreen.
// Storing the payload here lets SplashScreen pick it up after its own
// navigation and push ZiaratDetails on top of BottomBarScreen — so the
// back-button always returns to the home feed.

Map<String, String?>? pendingNotificationPayload;
bool splashCompleted = false;

// ─── FCM BACKGROUND HANDLER ───────────────────────────────────────────────────
// Runs in a separate isolate when the app is terminated or backgrounded.
// Because we rely on data-only FCM messages (no 'notification' block on the
// server side for topic broadcasts from the panel), this handler creates the
// visible AwesomeNotification that appears in the system tray.
//
// DEDUPLICATION: We derive the notification ID from message.messageId so
// that if FCM re-delivers the same message (a known FlutterFire edge case
// where background + onMessage can both fire on resume), AwesomeNotifications
// replaces the existing notification instead of showing a duplicate.

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  log('📩 [ZIARAT] Background FCM message: ${message.messageId}');

  final data = message.data;

  // The panel may send a notification block alongside the data block.
  // Prefer data fields; fall back to the notification block for title/body.
  final title = data['title']?.toString() ?? message.notification?.title ??
          'New Ziarat Update';
  final body = data['body']?.toString() ?? message.notification?.body ?? '';

  // Deterministic ID prevents duplicate notifications on double-delivery.
  final int notificationId = message.messageId != null
      ? message.messageId!.hashCode.abs().remainder(2147483647)
      : DateTime.now().millisecondsSinceEpoch.remainder(100000);

  log(
    '📲 [ZIARAT] Creating AwesomeNotification id=$notificationId title="$title"',
  );

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: notificationId,
      channelKey: 'ziarat_broadcast_channel',
      title: title,
      body: body,
      // Pass ALL data fields as payload so onActionReceivedMethod can
      // build the ZiaratDetails screen when the user taps the notification.
      // Expected keys from the panel:
      //   id, type, title, description, dua, lat, lng, image, audioGuide
      payload: data.map((k, v) => MapEntry(k, v.toString())),
      notificationLayout: NotificationLayout.BigText,
      actionType: ActionType.Default,
    ),
  );
}

// ─── NOTIFICATION TAP HANDLER (AwesomeNotifications) ─────────────────────────
// Called on EVERY notification tap — foreground, background, and terminated.
//
// Terminated-state flow
//   1. App launches cold → SplashScreen runs _handleNavigation()
//   2. onActionReceivedMethod fires almost immediately (navigator not ready yet)
//   3. We wait up to 8 s for the navigator to mount, then check splashCompleted:
//      • Splash still running → store payload in pendingNotificationPayload
//        SplashScreen picks it up after pushReplacement and routes correctly.
//      • Splash done → navigate directly (foreground / background tap).

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  log('🔔 [ZIARAT] Notification tapped: ${receivedAction.payload}');

  final payload = receivedAction.payload ?? {};
  if (payload.isEmpty) return;

  // Wait for the navigator widget tree to be ready (terminated cold-start).
  const maxWait = Duration(seconds: 8);
  const interval = Duration(milliseconds: 200);
  final deadline = DateTime.now().add(maxWait);

  while (navigatorKey.currentContext == null) {
    if (DateTime.now().isAfter(deadline)) {
      log(
        '⚠️ [ZIARAT] Navigator never ready — storing payload for splash pickup',
      );
      pendingNotificationPayload = payload;
      return;
    }
    await Future.delayed(interval);
  }

  // Splash still running → store for pickup after navigation.
  if (!splashCompleted) {
    log('⏳ [ZIARAT] Splash running — storing payload for pickup');
    pendingNotificationPayload = payload;
    return;
  }

  // Splash done → navigate directly.
  _routeToZiaratDetail(payload);
}

// ─── ROUTE HELPER ─────────────────────────────────────────────────────────────
// Builds a ZiaratDetails route from the notification payload and pushes it.
// Import paths match the existing ziarat_app project structure.

void _routeToZiaratDetail(Map<String, String?> payload) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    log('⚠️ [ZIARAT] No context available for routing');
    return;
  }

  final ziaratId = payload['id'];
  if (ziaratId == null || ziaratId.isEmpty) {
    log('⚠️ [ZIARAT] No id in payload — skipping deep link');
    return;
  }

  log('📲 [ZIARAT] Routing to ZiaratDetails id=$ziaratId');

  final imageUrl = payload['image'];

  // Build Data directly from the payload — no extra network round-trip needed.
  // FCM sends everything as strings, so we parse numbers explicitly.
  final data = Data(
    id: ziaratId,
    type: payload['type'],
    duaRaw: payload['dua'],
    lat: double.tryParse(payload['lat']?.toString() ?? ''),
    lng: double.tryParse(payload['lng']?.toString() ?? ''),
    images: (imageUrl != null && imageUrl.isNotEmpty) ? [imageUrl] : [],
    titleMap: payload['title'] != null ? {'en': payload['title']!} : {},
    descriptionMap: payload['description'] != null ? {'en': payload['description']!} : {},
    audioGuideMap: payload['audioGuide'] != null ? {'en': payload['audioGuide']!} : {},
    isActive: true,
  );

  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (_) => ZiaratDetails(data: data)),
  );
}

// ─── MAIN ─────────────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register the background FCM handler before any other Firebase call.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await di.init();

  // ── AwesomeNotifications setup ───────────────────────────────────────────
  await AwesomeNotifications().initialize(
    // Use your existing app icon drawable or null for the default.
    'resource://drawable/res_notification_app_icon',
    [
      NotificationChannel(
        channelKey: 'ziarat_broadcast_channel',
        channelName: 'Ziarat Broadcasts',
        channelDescription: 'Broadcast notifications for new Ziarat content',
        defaultColor: const Color(0xFF6B4C2A),
        // adjust to your brand colour
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      ),
    ],
    debug: true,
  );

  // Register the tap listener BEFORE runApp so terminated-state taps are caught.
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: onActionReceivedMethod,
  );

  // ── FCM permissions + topic subscription ────────────────────────────────
  // No sign-in required — every device subscribes to ZIARAT_APP immediately.
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  await FirebaseMessaging.instance.subscribeToTopic('ZIARAT_APP');
  log('✅ [ZIARAT] Subscribed to FCM topic: ZIARAT_APP');

  final savedLocale = await LanguageService.getSavedLanguage();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(savedLocale: savedLocale),
    ),
  );
}

// ─── APP ──────────────────────────────────────────────────────────────────────

class MyApp extends StatefulWidget {
  final Locale? savedLocale;

  const MyApp({super.key, this.savedLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupForegroundFCM();
  }

  // ── Foreground FCM listener ──────────────────────────────────────────────
  // When the app is open, FCM delivers the message to onMessage instead of
  // showing a system tray notification automatically. We forward it to
  // AwesomeNotifications so a heads-up banner appears consistently.
  void _setupForegroundFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('📩 [ZIARAT] Foreground FCM message: ${message.messageId}');

      final data = message.data;
      if (data.isEmpty) return;

      final title = data['title']?.toString() ?? message.notification?.title ?? 'New Ziarat Update';
      final body = data['body']?.toString() ?? message.notification?.body ?? '';

      final int notificationId = message.messageId != null
          ? message.messageId!.hashCode.abs().remainder(2147483647)
          : DateTime.now().millisecondsSinceEpoch.remainder(100000);

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'ziarat_broadcast_channel',
          title: title,
          body: body,
          payload: data.map((k, v) => MapEntry(k, v.toString())),
          notificationLayout: NotificationLayout.BigText,
          actionType: ActionType.Default,
        ),
      );
    });
  }

  // ── Font / theme helpers (unchanged from original) ───────────────────────

  TextTheme _bumpTextTheme(TextTheme t, double delta) {
    TextStyle? bump(TextStyle? s) {
      if (s == null) return null;
      if (s.fontSize == null) return s;
      return s.copyWith(fontSize: s.fontSize! + delta);
    }

    return t.copyWith(
      displayLarge: bump(t.displayLarge),
      displayMedium: bump(t.displayMedium),
      displaySmall: bump(t.displaySmall),
      headlineLarge: bump(t.headlineLarge),
      headlineMedium: bump(t.headlineMedium),
      headlineSmall: bump(t.headlineSmall),
      titleLarge: bump(t.titleLarge),
      titleMedium: bump(t.titleMedium),
      titleSmall: bump(t.titleSmall),
      bodyLarge: bump(t.bodyLarge),
      bodyMedium: bump(t.bodyMedium),
      bodySmall: bump(t.bodySmall),
      labelLarge: bump(t.labelLarge),
      labelMedium: bump(t.labelMedium),
      labelSmall: bump(t.labelSmall),
    );
  }

  String? _getFontForLocale(String? languageCode) {
    switch (languageCode) {
      case 'ur':
        return 'jameel-noori';
      case 'ar':
        return 'noto-sans';
      default:
        return GoogleFonts.raleway().fontFamily;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => CounterBloc())],
      child: GetMaterialApp(
        title: AppStrings.appTitle,
        translations: AppTranslations(),
        locale: widget.savedLocale ?? const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        // ── Wire up the global navigator key ──────────────────────────────
        // Required so onActionReceivedMethod can push routes from outside
        // the widget tree (terminated / background tap).
        navigatorKey: navigatorKey,
        builder: (context, child) {
          return SafeArea(
            top: false,
            bottom: true,
            child: child ?? const SizedBox.shrink(),
          );
        },
        theme: (() {
          final base = ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            fontFamily: _getFontForLocale(widget.savedLocale?.languageCode),
          );
          final lang = widget.savedLocale?.languageCode ?? 'en';
          if (lang != 'ur') return base;
          return base.copyWith(
            textTheme: _bumpTextTheme(base.textTheme, 6),
            primaryTextTheme: _bumpTextTheme(base.primaryTextTheme, 6),
          );
        })(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}