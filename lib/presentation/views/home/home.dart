import 'dart:async';
import 'dart:convert';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/constants/text_responsive.dart';
import 'package:ziarat_app/presentation/elements/container.dart';

import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';

// ── Data Models ───────────────────────────────────────────────────────────────
class AyatModel {
  final int index;
  final String arabicAyat;
  final String urduAyat;
  final String englishAyat;

  AyatModel({
    required this.index,
    required this.arabicAyat,
    required this.urduAyat,
    required this.englishAyat,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) => AyatModel(
    index: json['index'],
    arabicAyat: json['arabic_ayat'],
    urduAyat: json['urdu_ayat'],
    englishAyat: json['english_ayat'],
  );
}

class HadithModel {
  final int index;
  final String arabicHadith;
  final String urduHadith;
  final String englishHadith;

  HadithModel({
    required this.index,
    required this.arabicHadith,
    required this.urduHadith,
    required this.englishHadith,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) => HadithModel(
    index: json['index'],
    arabicHadith: json['arabic_hadith'],
    urduHadith: json['urdu_hadith'],
    englishHadith: json['english_hadith'],
  );
}

class _PrayerEntry {
  final String name;
  final DateTime time;
  _PrayerEntry(this.name, this.time);
}

class _PrayerDisplay {
  final String name;
  final String time;
  final String iconPath;
  _PrayerDisplay(this.name, this.time, this.iconPath);
}

// ── Home Widget ───────────────────────────────────────────────────────────────
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String _cachedLatKey = 'home_cached_lat';
  static const String _cachedLngKey = 'home_cached_lng';
  static const String _cachedLocationNameKey = 'home_cached_location_name';

  // ── Clock ──
  late Timer _clockTimer;
  String _currentTime = "";
  String _hijriDate = "";
  String _gregorianDate = "";
  String _hijriDateOnly = "";

  // ── Location ──
  String _locationName = "Locating...";
  double _latitude = 21.3891;
  double _longitude = 39.8579;

  // ── Prayer Times ──
  PrayerTimes? _prayerTimes;
  String _nextPrayerName = "";
  String _remainingTime = "";
  Timer? _countdownTimer;

  // ── Daily Ayat & Hadith ──
  AyatModel? _todayAyat;
  HadithModel? _todayHadith;

  @override
  void initState() {
    super.initState();
    _bootstrapHome();
  }

  Future<void> _bootstrapHome() async {
    // intl requires locale data initialization when using DateFormat with locale.
    await initializeDateFormatting('en_US', null);
    await initializeDateFormatting('ur_PK', null);
    await initializeDateFormatting('ar_SA', null);

    if (!mounted) return;
    _startClock();
    _initPrayerTimes();
    _loadDailyContent();
  }

  // ── Daily Content Loader ───────────────────────────────────────────────

  Future<void> _loadDailyContent() async {
    await Future.wait([_loadDailyAyat(), _loadDailyHadith()]);
  }

  Future<void> _loadDailyAyat() async {
    try {
      final String raw =
      await rootBundle.loadString('assets/json/ayat.json');
      final Map<String, dynamic> json = jsonDecode(raw);
      final List data = json['data'];
      final List<AyatModel> ayatList =
      data.map((e) => AyatModel.fromJson(e)).toList();

      final int dayOfYear = _getDayOfYear();
      final int todayIndex = dayOfYear % ayatList.length;

      if (mounted) {
        setState(() => _todayAyat = ayatList[todayIndex]);
      }
    } catch (e) {
      debugPrint('❌ Failed to load ayat.json: $e');
    }
  }

  Future<void> _loadDailyHadith() async {
    try {
      final String raw =
      await rootBundle.loadString('assets/json/hadith.json');
      final Map<String, dynamic> json = jsonDecode(raw);
      final List data = json['data'];
      final List<HadithModel> hadithList =
      data.map((e) => HadithModel.fromJson(e)).toList();

      final int dayOfYear = _getDayOfYear();
      final int todayIndex = dayOfYear % hadithList.length;

      if (mounted) {
        setState(() => _todayHadith = hadithList[todayIndex]);
      }
    } catch (e) {
      debugPrint('❌ Failed to load hadith.json: $e');
    }
  }

  int _getDayOfYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    return now.difference(startOfYear).inDays;
  }

  // ── Clock ──────────────────────────────────────────────────────────────────
  void _startClock() {
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final hijri = HijriCalendar.fromDate(now);
    final langCode = Get.locale?.languageCode ?? 'en';
    final dateLocale =
        (langCode == 'ar') ? 'ar_SA' : (langCode == 'ur') ? 'ur_PK' : 'en_US';

    String hijriMonth;
    String hijriSuffix;

    if (langCode == 'ar') {
      const months = <String>[
        'محرم',
        'صفر',
        'ربيع الأول',
        'ربيع الثاني',
        'جمادى الأولى',
        'جمادى الآخرة',
        'رجب',
        'شعبان',
        'رمضان',
        'شوال',
        'ذو القعدة',
        'ذو الحجة',
      ];
      hijriMonth = (hijri.hMonth >= 1 && hijri.hMonth <= 12)
          ? months[hijri.hMonth - 1]
          : hijri.longMonthName;
      hijriSuffix = 'هـ';
    } else if (langCode == 'ur') {
      const months = <String>[
        'محرم',
        'صفر',
        'ربیع الاول',
        'ربیع الثانی',
        'جمادی الاول',
        'جمادی الثانی',
        'رجب',
        'شعبان',
        'رمضان',
        'شوال',
        'ذوالقعدہ',
        'ذوالحجہ',
      ];
      hijriMonth = (hijri.hMonth >= 1 && hijri.hMonth <= 12)
          ? months[hijri.hMonth - 1]
          : hijri.longMonthName;
      hijriSuffix = 'ہجری';
    } else {
      hijriMonth = hijri.longMonthName;
      hijriSuffix = 'AH';
    }

    final gregorianFormatted =
        DateFormat('EEE, MMM dd, yyyy', dateLocale).format(now);
    final hijriFormatted =
        '${hijri.hDay} $hijriMonth ${hijri.hYear} $hijriSuffix';

    setState(() {
      _currentTime = DateFormat('hh:mm').format(now);
      _hijriDate =
          '$hijriFormatted  |  $gregorianFormatted';
      _gregorianDate = gregorianFormatted;
      _hijriDateOnly = hijriFormatted;
    });
  }

  // ── Location + Prayer Times ────────────────────────────────────────────────
  Future<bool> _loadCachedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_cachedLatKey);
    final lng = prefs.getDouble(_cachedLngKey);
    final locationName = prefs.getString(_cachedLocationNameKey);

    if (lat == null || lng == null) return false;

    if (!mounted) return true;
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _locationName =
          (locationName != null && locationName.trim().isNotEmpty)
              ? locationName
              : AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr;
    });
    return true;
  }

  Future<void> _saveCachedLocation({
    required double lat,
    required double lng,
    required String locationName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_cachedLatKey, lat);
    await prefs.setDouble(_cachedLngKey, lng);
    await prefs.setString(_cachedLocationNameKey, locationName);
  }

  Future<void> _initPrayerTimes() async {
    final hasCachedLocation = await _loadCachedLocation();
    if (hasCachedLocation) {
      _calcPrayerTimes(_latitude, _longitude);
      return;
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted)
          setState(() => _locationName =
              AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr);
        _calcPrayerTimes(_latitude, _longitude);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      }

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty && mounted) {
          final place = placemarks.first;
          final city = place.locality?.isNotEmpty == true
              ? place.locality!
              : place.subAdministrativeArea ?? '';
          final country = place.country ?? '';
          setState(() {
            _locationName = city.isNotEmpty && country.isNotEmpty
                ? '$city, $country'
                : country.isNotEmpty
                ? country
                : AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr;
          });
          await _saveCachedLocation(
            lat: position.latitude,
            lng: position.longitude,
            locationName: _locationName,
          );
        }
      } catch (_) {
        if (mounted)
          setState(() => _locationName =
              AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr);
        await _saveCachedLocation(
          lat: position.latitude,
          lng: position.longitude,
          locationName: AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr,
        );
      }
    } catch (_) {
      if (mounted)
        setState(() =>
        _locationName = AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr);
    }

    _calcPrayerTimes(_latitude, _longitude);
  }

  void _calcPrayerTimes(double lat, double lng) {
    final coordinates = Coordinates(lat, lng);
    final params = CalculationMethodParameters.karachi()
      ..madhab = Madhab.hanafi;

    final pt = PrayerTimes(
      date: DateTime.now(),
      coordinates: coordinates,
      calculationParameters: params,
    );

    if (mounted) setState(() => _prayerTimes = pt);
    _startCountdown();
  }

  void _startCountdown() {
    _updateNextPrayer();
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _updateNextPrayer();
    });
  }

  void _updateNextPrayer() {
    if (_prayerTimes == null) return;

    final now = DateTime.now();
    final pt = _prayerTimes!;

    final prayerMap = {
      'Fajr': pt.fajr.toLocal(),
      'Zuhr': pt.dhuhr.toLocal(),
      'Asr': pt.asr.toLocal(),
      'Maghrib': pt.maghrib.toLocal(),
      'Isha': pt.isha.toLocal(),
    };

    DateTime? nextTime;
    String? nextName;

    for (final entry in prayerMap.entries) {
      if (now.isBefore(entry.value)) {
        nextTime = entry.value;
        nextName = entry.key;
        break;
      }
    }

    nextTime ??= pt.fajrAfter.toLocal();
    nextName ??= 'Fajr';

    if (now.weekday == DateTime.friday && nextName == 'Zuhr') {
      nextName = 'Jummah';
    }

    final diff = nextTime.difference(now);

    if (mounted) {
      setState(() {
        _nextPrayerName = nextName!;
        _remainingTime = '${diff.inHours.toString().padLeft(2, '0')}:'
            '${(diff.inMinutes % 60).toString().padLeft(2, '0')}:'
            '${(diff.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    }
  }

  String _currentPrayerName() {
    if (_prayerTimes == null) return '';
    final now = DateTime.now();
    final pt = _prayerTimes!;

    final list = [
      _PrayerEntry('Isha', pt.isha.toLocal()),
      _PrayerEntry('Maghrib', pt.maghrib.toLocal()),
      _PrayerEntry('Asr', pt.asr.toLocal()),
      _PrayerEntry('Zuhr', pt.dhuhr.toLocal()),
      _PrayerEntry('Fajr', pt.fajr.toLocal()),
    ];

    for (final p in list) {
      if (now.isAfter(p.time)) return p.name;
    }
    return 'Isha';
  }

  String _fmt(DateTime dt) => DateFormat('hh:mm a').format(dt.toLocal());

  String _getLocaleText({
    required String arabic,
    required String urdu,
    required String english,
  }) {
    final lang = Get.locale?.languageCode ?? 'en';
    switch (lang) {
      case 'ar':
        return arabic;
      case 'ur':
        return urdu;
      default:
        return english;
    }
  }

  // ── RTL Date Display ──────────────────────────────────────────────────────
  Widget _buildRtlDateDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            _hijriDateOnly,
            style: FrontEndConfig.subHeadingTextStyle,
            textAlign: TextAlign.right,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '|',
            style: FrontEndConfig.subHeadingTextStyle,
          ),
        ),
        Flexible(
          child: Text(
            _gregorianDate,
            style: FrontEndConfig.subHeadingTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final langCode = Get.locale?.languageCode ?? 'en';
    final isRtl = langCode == 'ar' || langCode == 'ur';

    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),
          Positioned.fill(
            child:
            Image.asset(AssetConstant.backgroundimage, fit: BoxFit.cover),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(AssetConstant.homeLeft,
                width: width * 0.35,
                height: height * 0.22,
                fit: BoxFit.cover),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(AssetConstant.homeRight,
                width: width * 0.35,
                height: height * 0.22,
                fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(AssetConstant.lamp,
                height: height * 0.32, width: width * 0.38),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    0.13.height(context),

                    // ── Location Pill ──
                    MyContainer(
                      height: height * 0.04,
                      width: width * 0.65,
                      decoration: BoxDecoration(
                        gradient: FrontEndConfig.btnBorderColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: MyContainer(
                          decoration: BoxDecoration(
                            color: FrontEndConfig.listTileColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AssetConstant.location,
                                  width: 15, height: 15),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _locationName,
                                  style: FrontEndConfig.subHeadingTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    0.015.height(context), // ✅ gap between location pill and clock

                    // ── Clock ──
                    Text(
                      _currentTime,
                      style: FrontEndConfig.languageHeadingTextStyle.copyWith(
                        fontSize: width * 0.22,
                        height: 1,
                      ),
                    ),
                    0.01.height(context),

                    // ── Hijri + Gregorian Date ──
                    if (isRtl)
                      _buildRtlDateDisplay()
                    else
                      Text(
                        _hijriDate,
                        style: FrontEndConfig.subHeadingTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    0.02.height(context),

                    // ── Next Prayer Bar ──
                    MyContainer(
                      height: height * 0.060,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: FrontEndConfig.btnBorderColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: MyContainer(
                          decoration: BoxDecoration(
                            color: FrontEndConfig.listTileColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(AppStrings.nextPrayerLabelTxt.tr,
                                    style: FrontEndConfig.subHeadingTextStyle),
                                ShaderMask(
                                  shaderCallback: (b) => FrontEndConfig
                                      .btnBorderColor
                                      .createShader(b),
                                  child: Text(
                                    _nextPrayerName.isEmpty
                                        ? "--"
                                        : _localizedNamazName(_nextPrayerName),
                                    style: FrontEndConfig.headingTextStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: VerticalDivider(
                                      thickness: 1, color: Colors.grey),
                                ),
                                Text(AppStrings.remainingLabelTxt.tr,
                                    style: FrontEndConfig.subHeadingTextStyle),
                                ShaderMask(
                                  shaderCallback: (b) => FrontEndConfig
                                      .btnBorderColor
                                      .createShader(b),
                                  child: Text(
                                    _remainingTime.isEmpty
                                        ? "--:--:--"
                                        : _remainingTime,
                                    style: FrontEndConfig.headingTextStyle
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    0.02.height(context),

                    // ── Ayat of the Day ──
                    Align(
                      alignment:
                      isRtl ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        AppStrings.ayatOfTheDayTxt.tr,
                        style: FrontEndConfig.mainTextStyle,
                      ),
                    ),
                    0.02.height(context),
                    _buildAyatCard(context),
                    0.02.height(context),

                    // ── Hadith of the Day ──
                    Align(
                      alignment:
                      isRtl ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        AppStrings.hadithOfTheDayTxt.tr,
                        style: FrontEndConfig.mainTextStyle,
                      ),
                    ),
                    0.02.height(context),
                    _buildHadithCard(context),
                    0.02.height(context),

                    // ── Prayer Times ──
                    Align(
                      alignment:
                      isRtl ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        AppStrings.prayerTimesTxt.tr,
                        style: FrontEndConfig.mainTextStyle,
                      ),
                    ),
                    0.02.height(context),
                    _buildPrayerTimesCard(context, width, height),
                    0.02.height(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Prayer Times Card ──────────────────────────────────────────────────────
  Widget _buildPrayerTimesCard(
      BuildContext context, double width, double height) {
    final pt = _prayerTimes;
    final active = _currentPrayerName();

    final prayers = [
      _PrayerDisplay('Fajr',
          pt != null ? _fmt(pt.fajr) : '--:--', AssetConstant.fajar),
      _PrayerDisplay(
          'Zuhr', pt != null ? _fmt(pt.dhuhr) : '--:--', AssetConstant.zuhr),
      _PrayerDisplay(
          'Asr', pt != null ? _fmt(pt.asr) : '--:--', AssetConstant.asar),
      _PrayerDisplay('Maghrib',
          pt != null ? _fmt(pt.maghrib) : '--:--', AssetConstant.magrib),
      _PrayerDisplay(
          'Isha', pt != null ? _fmt(pt.isha) : '--:--', AssetConstant.isha),
    ];

    return MyContainer(
      height: height * 0.15,
      decoration: BoxDecoration(
        gradient: FrontEndConfig.btnBorderColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: MyContainer(
        decoration: BoxDecoration(
          color: FrontEndConfig.listTileColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.35),
              child: ClipRRect(
                borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(20)),
                child: Image.asset(
                  AssetConstant.prayerTimeDesign,
                  height: height * 0.35,
                  width: width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < prayers.length; i++) ...[
                    _buildPrayerColumn(
                        context, prayers[i], prayers[i].name == active, width),
                    if (i < prayers.length - 1) _buildDivider(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerColumn(BuildContext context, _PrayerDisplay p,
      bool isActive, double width) {
    if (isActive) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ShaderMask(
            shaderCallback: (b) =>
                FrontEndConfig.btnBorderColor.createShader(b),
            child: Text(_localizedNamazName(p.name),
                style:
                FrontEndConfig.bodyTextStyle.copyWith(color: Colors.white)),
          ),
          0.01.height(context),
          ShaderMask(
            shaderCallback: (b) =>
                FrontEndConfig.btnBorderColor.createShader(b),
            blendMode: BlendMode.srcIn,
            child: Image.asset(p.iconPath,
                width: width * 0.06,
                height: width * 0.06,
                color: Colors.white),
          ),
          0.01.height(context),
          ShaderMask(
            shaderCallback: (b) =>
                FrontEndConfig.btnBorderColor.createShader(b),
            child: Text(p.time,
                style: FrontEndConfig.packageTextStyle
                    .copyWith(color: Colors.white)),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(_localizedNamazName(p.name),
            style: FrontEndConfig.bodyTextStyle),
        0.01.height(context),
        Image.asset(p.iconPath,
            width: width * 0.06,
            height: width * 0.06,
            color: FrontEndConfig.iconColor),
        0.01.height(context),
        Text(p.time, style: FrontEndConfig.packageTextStyle),
      ],
    );
  }

  // ── Ayat Card ──────────────────────────────────────────────────────────────
  Widget _buildAyatCard(BuildContext context) {
    if (_todayAyat == null) {
      return _buildLoadingCard(context);
    }

    final ayat = _todayAyat!;

    return MyContainer(
      decoration: BoxDecoration(
        gradient: FrontEndConfig.btnBorderColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: MyContainer(
          decoration: BoxDecoration(
            color: FrontEndConfig.listTileColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  child: Image.asset(AssetConstant.ayatDesign,
                      width: 200, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      ayat.arabicAyat,
                      style: TextStyle(
                          fontSize: context.responsiveFont(18),
                          color: Colors.white,
                          fontFamily: "al-majeed-quranic"),
                      textAlign: TextAlign.center,
                    ),
                    0.02.height(context),
                    _buildDividerLinear(),
                    0.02.height(context),
                    Text(
                      ayat.urduAyat,
                      style: TextStyle(
                          fontSize: context.responsiveFont(13),
                          color: Colors.white,
                          fontFamily: "jameel-noori"),
                      textAlign: TextAlign.center,
                    ),
                    0.02.height(context),
                    _buildDividerLinear(),
                    0.02.height(context),
                    Text(
                      ayat.englishAyat,
                      style: FrontEndConfig.bodyTextStyle.copyWith(
                        fontSize: context.responsiveFont(12),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    0.01.height(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hadith Card ────────────────────────────────────────────────────────────
  Widget _buildHadithCard(BuildContext context) {
    if (_todayHadith == null) {
      return _buildLoadingCard(context);
    }

    final hadith = _todayHadith!;

    return MyContainer(
      decoration: BoxDecoration(
        gradient: FrontEndConfig.btnBorderColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: MyContainer(
          decoration: BoxDecoration(
            color: FrontEndConfig.listTileColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  child: Image.asset(AssetConstant.ayatDesign,
                      width: 200, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      hadith.arabicHadith,
                      style: TextStyle(
                          fontSize: context.responsiveFont(18),
                          color: Colors.white,
                          fontFamily: "al-majeed-quranic"),
                      textAlign: TextAlign.center,
                    ),
                    0.02.height(context),
                    _buildDividerLinear(),
                    0.02.height(context),
                    Text(
                      hadith.urduHadith,
                      style: TextStyle(
                          fontSize: context.responsiveFont(13),
                          color: Colors.white,
                          fontFamily: "jameel-noori"),
                      textAlign: TextAlign.center,
                    ),
                    0.02.height(context),
                    _buildDividerLinear(),
                    0.02.height(context),
                    Text(
                      hadith.englishHadith,
                      style: FrontEndConfig.bodyTextStyle.copyWith(
                        fontSize: context.responsiveFont(12),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    0.01.height(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Loading Placeholder ────────────────────────────────────────────────────
  Widget _buildLoadingCard(BuildContext context) {
    return MyContainer(
      decoration: BoxDecoration(
        gradient: FrontEndConfig.btnBorderColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: MyContainer(
          decoration: BoxDecoration(
            color: FrontEndConfig.listTileColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xffFAD25B)),
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String _localizedNamazName(String key) {
    final lang = Get.locale?.languageCode ?? 'en';

    if (lang == 'ar') {
      switch (key) {
        case 'Fajr':
          return 'الفجر';
        case 'Zuhr':
          return 'الظهر';
        case 'Asr':
          return 'العصر';
        case 'Maghrib':
          return 'المغرب';
        case 'Isha':
          return 'العشاء';
        case 'Jummah':
          return 'الجمعة';
        default:
          return key;
      }
    }

    if (lang == 'ur') {
      switch (key) {
        case 'Fajr':
          return 'فجر';
        case 'Zuhr':
          return 'ظہر';
        case 'Asr':
          return 'عصر';
        case 'Maghrib':
          return 'مغرب';
        case 'Isha':
          return 'عشاء';
        case 'Jummah':
          return 'جمعہ';
        default:
          return key;
      }
    }

    // English (default)
    return key;
  }

  Widget _buildDivider() {
    return const SizedBox(
        height: 75, child: VerticalDivider(thickness: 1, color: Colors.grey));
  }

  Widget _buildDividerLinear() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        height: 1,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffA0832C), Color(0xffFAD25B), Color(0xff9B8030)],
          ),
        ),
      ),
    );
  }
}