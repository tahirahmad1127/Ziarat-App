import 'dart:async';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/constants/text_responsive.dart';
import 'package:ziarat_app/presentation/elements/container.dart';

import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ── Clock ──
  late Timer _clockTimer;
  String _currentTime = "";
  String _hijriDate = "";

  // ── Location ──
  String _locationName = "Locating...";
  double _latitude = 21.3891; // fallback: Makkah
  double _longitude = 39.8579;

  // ── Prayer Times ──
  PrayerTimes? _prayerTimes;
  String _nextPrayerName = "";
  String _remainingTime = "";
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startClock();
    _initPrayerTimes();
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
    setState(() {
      _currentTime = DateFormat('hh:mm').format(now);
      _hijriDate =
      '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} AH  |  ${DateFormat('EEE, MMM dd, yyyy').format(now)}';
    });
  }

  // ── Location + Prayer Times ────────────────────────────────────────────────
  Future<void> _initPrayerTimes() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _locationName = AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr);
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

      // ── Reverse geocode → "City, Country" ──
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
        }
      } catch (_) {
        if (mounted) setState(() => _locationName = AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr);
      }
    } catch (_) {
      if (mounted) setState(() => _locationName = AppStrings.fallbackLocationMakkahSaudiArabiaTxt.tr);
    }

    _calcPrayerTimes(_latitude, _longitude);
  }

  // ── Prayer Time Calculation ────────────────────────────────────────────────
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

  // ── Countdown ──────────────────────────────────────────────────────────────
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

    // ── Use .toLocal() so times match device timezone ──
    final prayerMap = {
      'Fajr': pt.fajr.toLocal(),
      'Dhuhr': pt.dhuhr.toLocal(),
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

    // All prayers passed — use fajrAfter (next day Fajr)
    nextTime ??= pt.fajrAfter.toLocal();
    nextName ??= 'Fajr';

    // Friday Dhuhr → Jummah
    if (now.weekday == DateTime.friday && nextName == 'Dhuhr') {
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

  // ── Active prayer for gradient highlight ──────────────────────────────────
  String _currentPrayerName() {
    if (_prayerTimes == null) return '';
    final now = DateTime.now();
    final pt = _prayerTimes!;

    // ── Use .toLocal() so comparison is correct ──
    final list = [
      _PrayerEntry('Isha', pt.isha.toLocal()),
      _PrayerEntry('Maghrib', pt.maghrib.toLocal()),
      _PrayerEntry('Asr', pt.asr.toLocal()),
      _PrayerEntry('Dhuhr', pt.dhuhr.toLocal()),
      _PrayerEntry('Fajr', pt.fajr.toLocal()),
    ];

    for (final p in list) {
      if (now.isAfter(p.time)) return p.name;
    }
    return 'Isha';
  }

  // ── Format time in local timezone ──
  String _fmt(DateTime dt) => DateFormat('hh:mm a').format(dt.toLocal());

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
                width: width * 0.35, height: height * 0.22, fit: BoxFit.cover),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(AssetConstant.homeRight,
                width: width * 0.35, height: height * 0.22, fit: BoxFit.cover),
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

                    // ── Clock ──
                    Text(
                      _currentTime,
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.22,
                        color: FrontEndConfig.textColor,
                        height: 1,
                      ),
                    ),
                    0.01.height(context),

                    // ── Hijri + Gregorian Date ──
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
                                        : _nextPrayerName,
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
                      alignment: Alignment.centerLeft,
                      child: Text(AppStrings.ayatOfTheDayTxt.tr,
                          style: FrontEndConfig.mainTextStyle),
                    ),
                    0.02.height(context),
                    _buildAyatCard(context),
                    0.02.height(context),

                    // ── Hadith of the Day ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppStrings.hadithOfTheDayTxt.tr,
                          style: FrontEndConfig.mainTextStyle),
                    ),
                    0.02.height(context),
                    _buildHadithCard(context),
                    0.02.height(context),

                    // ── Prayer Times ──
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppStrings.prayerTimesTxt.tr,
                          style: FrontEndConfig.mainTextStyle),
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
      _PrayerDisplay('Zuhr',
          pt != null ? _fmt(pt.dhuhr) : '--:--', AssetConstant.zuhr),
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
            child: Text(p.name,
                style: FrontEndConfig.bodyTextStyle
                    .copyWith(color: Colors.white)),
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
        Text(p.name, style: FrontEndConfig.bodyTextStyle),
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
                      "وَٱلَّذِينَ ءَامَنُوا۟ وَعَمِلُوا۟ ٱلصَّـٰلِحَـٰتِ لَنُكَفِّرَنَّ عَنْهُمْ سَيِّـَٔاتِهِمْ وَلَنَجْزِيَنَّهُمْ أَحْسَنَ ٱلَّذِى كَانُوا۟ يَعْمَلُونَ",
                      style: TextStyle(
                          fontSize: context.responsiveFont(18),
                          color: Colors.white,
                          fontFamily: "al-majeed"),
                      textAlign: TextAlign.center,
                    ),
                    0.02.height(context),
                    _buildDividerLinear(),
                    0.02.height(context),
                    Text(
                      "جو لوگ ایمان لائے اور نیک عمل کرتے رہے ہم ان کے گناہوں کو ضرور معاف کر دیں گے اور ان کو ان کے بہترین اعمال کے مطابق جزا دیں گے۔",
                      style: TextStyle(
                          fontSize: context.responsiveFont(13),
                          color: Colors.white,
                          fontFamily: "al-majeed"),
                      textAlign: TextAlign.center,
                    ),
                    0.02.height(context),
                    _buildDividerLinear(),
                    0.02.height(context),
                    Text(
                      '"On that Day people will proceed in separate groups to be shown the consequences of their deeds." (Az-Zalzalah 99:6)',
                      style: TextStyle(
                          fontSize: context.responsiveFont(12),
                          color: Colors.white,
                          fontFamily: GoogleFonts.raleway().fontFamily),
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
                      "لِقَوْلِهِ تَعَالى: {قُلْ مَا يَعْبَؤُا بِكُمْ رَبِّ لَوْلَا دُعَاؤُكُمْ} [الفرقان: ٧٧] وَمَعْنَى الدُّعاءِ في اللُّغَةِ (الإيمان)َ",
                      style: TextStyle(
                          fontSize: context.responsiveFont(18),
                          color: Colors.white,
                          fontFamily: "al-majeed"),
                      textAlign: TextAlign.center,
                    ),
                    0.02.height(context),
                    _buildDividerLinear(),
                    0.02.height(context),
                    Text(
                      "اللہ تعالیٰ کے اس فرمان کی وجہ سے: آپ کہہ دیجیے کہ میرا رب تمہاری کوئی پروا نہیں کرتا اگر تمہاری دعا نہ ہو [الفرقان: ٧٧] اور لغت میں دعاء کا معنی ایمان ہے۔",
                      style: TextStyle(
                          fontSize: context.responsiveFont(13),
                          color: Colors.white,
                          fontFamily: "al-majeed"),
                      textAlign: TextAlign.center,
                    ),
                    0.02.height(context),
                    _buildDividerLinear(),
                    0.02.height(context),
                    Text(
                      'Your invocation means your faith. And Allah تعالى said: "Say (O Muhammad ﷺ): My Lord pays attention to you only because of your invocation." (V.25:77)',
                      style: TextStyle(
                          fontSize: context.responsiveFont(12),
                          color: Colors.white,
                          fontFamily: GoogleFonts.raleway().fontFamily),
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

  // ── Helpers ────────────────────────────────────────────────────────────────
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

// ── Data Models ───────────────────────────────────────────────────────────────
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