import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziarat_app/infrastructure/models/ziarat_details.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';

class ZiaratDetails extends StatefulWidget {
  final Data data;

  const ZiaratDetails({
    super.key,
    required this.data,
  });

  @override
  State<ZiaratDetails> createState() => _ZiaratDetailsState();
}

class _ZiaratDetailsState extends State<ZiaratDetails> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  late List<String> images;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    images = (widget.data.images != null && widget.data.images!.isNotEmpty)
        ? widget.data.images!
        : [AssetConstant.masjid, AssetConstant.masjid2, AssetConstant.masjid3];

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          _isLoading = false;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _audioPlayer.onLog.listen((msg) {
      debugPrint("AUDIO LOG: $msg");
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // ── FIX 1: Open Google Maps ──────────────────────────────────────────────────
  Future<void> _openGoogleMaps() async {
    final lat = widget.data.lat;
    final lng = widget.data.lng;

    Uri uri;
    if (lat != null && lng != null) {
      // If the model has lat/lng use them directly
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    } else {
      // Fallback: search by title name
      final query = Uri.encodeComponent(widget.data.title ?? 'Ziarat');
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  // ── FIX 3: Audio toggle + show bottom sheet ──────────────────────────────────
  Future<void> _toggleAudio() async {
    final audioUrl = widget.data.audioGuide;

    if (audioUrl == null || audioUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.noAudioGuideAvailableTxt.tr)),
      );
      return;
    }

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() => _isLoading = true);
      try {
        await _audioPlayer.play(UrlSource(audioUrl));
      } catch (e) {
        debugPrint("AUDIO ERROR: $e");
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.failedToPlayAudioTxt.tr}: $e')),
          );
          return;
        }
      }
    }

    // Show audio controls bottom sheet
    if (mounted) {
      _showAudioBottomSheet();
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showAudioBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            // Keep sheet in sync with player state
            _audioPlayer.onPlayerStateChanged.listen((_) {
              if (mounted) setSheetState(() {});
            });
            _audioPlayer.onPositionChanged.listen((_) {
              if (mounted) setSheetState(() {});
            });
            _audioPlayer.onDurationChanged.listen((_) {
              if (mounted) setSheetState(() {});
            });

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: MyContainer(
                decoration: BoxDecoration(
                  gradient: FrontEndConfig.btnBorderColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: MyContainer(
                    decoration: BoxDecoration(
                      color: FrontEndConfig.backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag handle
                          Container(
                            width: 89,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Text(
                            widget.data.title ?? '',
                            style: FrontEndConfig.headingTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Audio Guide',
                            style: FrontEndConfig.subHeadingTextStyle,
                          ),
                          const SizedBox(height: 16),

                          // Progress slider
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xffC89C18),
                              inactiveTrackColor: Colors.white24,
                              thumbColor: const Color(0xffC89C18),
                              overlayColor: const Color(0xffC89C18).withOpacity(0.2),
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            ),
                            child: Slider(
                              value: _duration.inSeconds > 0
                                  ? _position.inSeconds
                                  .toDouble()
                                  .clamp(0, _duration.inSeconds.toDouble())
                                  : 0,
                              min: 0,
                              max: _duration.inSeconds > 0
                                  ? _duration.inSeconds.toDouble()
                                  : 1,
                              onChanged: (val) async {
                                await _audioPlayer
                                    .seek(Duration(seconds: val.toInt()));
                              },
                            ),
                          ),

                          // Time labels
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_position),
                                  style: FrontEndConfig.subHeadingTextStyle,
                                ),
                                Text(
                                  _formatDuration(_duration),
                                  style: FrontEndConfig.subHeadingTextStyle,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Controls row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Rewind 10s
                              IconButton(
                                onPressed: () async {
                                  final newPos = _position - const Duration(seconds: 10);
                                  await _audioPlayer.seek(
                                    newPos < Duration.zero ? Duration.zero : newPos,
                                  );
                                },
                                icon: const Icon(Icons.replay_10, color: Colors.white, size: 30),
                              ),

                              const SizedBox(width: 16),

                              // Play / Pause
                              GestureDetector(
                                onTap: () async {
                                  if (_isPlaying) {
                                    await _audioPlayer.pause();
                                  } else {
                                    await _audioPlayer.resume();
                                  }
                                  setSheetState(() {});
                                },
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffC89C18),
                                  ),
                                  child: _isLoading
                                      ? const Padding(
                                    padding: EdgeInsets.all(14),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Forward 10s
                              IconButton(
                                onPressed: () async {
                                  final newPos = _position + const Duration(seconds: 10);
                                  await _audioPlayer.seek(
                                    newPos > _duration ? _duration : newPos,
                                  );
                                },
                                icon: const Icon(Icons.forward_10, color: Colors.white, size: 30),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final langCode = Get.locale?.languageCode ?? 'en';
    final currentDirection =
        Directionality.maybeOf(context) ?? TextDirection.ltr;
    final bool isRtl = currentDirection == TextDirection.rtl ||
        langCode == 'ar' ||
        langCode == 'ur';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            Container(color: FrontEndConfig.backgroundColor),
            Positioned.fill(
              child:
              Image.asset(AssetConstant.backgroundimage, fit: BoxFit.cover),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 380,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() => currentIndex = index);
                            },
                            itemBuilder: (context, index) {
                              final img = images[index];
                              return img.startsWith('http')
                                  ? Image.network(
                                img,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  AssetConstant.masjid,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Image.asset(img, fit: BoxFit.cover);
                            },
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 100,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 278.0, left: 20, right: 20),
                          child: SizedBox(
                            height: 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final img = images[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() => currentIndex = index);
                                    _pageController.animateToPage(
                                      index,
                                      duration:
                                      const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffA0832C),
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: img.startsWith('http')
                                          ? Image.network(
                                        img,
                                        width: 85,
                                        height: 75,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Image.asset(
                                              AssetConstant.masjid,
                                              width: 85,
                                              height: 75,
                                              fit: BoxFit.cover,
                                            ),
                                      )
                                          : Image.asset(
                                        img,
                                        width: 85,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Back button
                        Positioned(
                          top: 25,
                          left: isRtl ? null : 20,
                          right: isRtl ? 20 : null,
                          child: GestureDetector(
                            onTap: () => NavigatorHelper.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xff243243),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    0.02.height(context),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyContainer(
                                height: 34,
                                decoration: BoxDecoration(
                                  gradient: FrontEndConfig.btnBorderColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: MyContainer(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: FrontEndConfig.listTileColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        data.type ?? "",
                                        style: FrontEndConfig.btnTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              MyContainer(
                                height: 34,
                                width: 89,
                                decoration: BoxDecoration(
                                  gradient: FrontEndConfig.btnBorderColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: MyContainer(
                                    decoration: BoxDecoration(
                                      color: FrontEndConfig.listTileColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: _toggleAudio,
                                          child: _isLoading
                                              ? const SizedBox(
                                            width: 21,
                                            height: 21,
                                            child:
                                            CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                              : Image.asset(
                                            AssetConstant.speaker,
                                            width: 21,
                                            height: 21,
                                            color: _isPlaying
                                                ? const Color(0xffC89C18)
                                                : FrontEndConfig
                                                .listTileIconColor,
                                          ),
                                        ),
                                        _buildDividerLinear(),
                                        GestureDetector(
                                          onTap: () => _showDuaBottomSheet(
                                              context, data.dua),
                                          child: Image.asset(
                                            AssetConstant.pray,
                                            width: 22,
                                            height: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          0.02.height(context),

                          Text(
                            data.title ?? "",
                            style: FrontEndConfig.languageHeadingTextStyle,
                          ),

                          0.02.height(context),

                          Row(
                            children: [
                              Image.asset(AssetConstant.location, width: 18),
                              0.02.width(context),
                              Text(
                                data.type ?? "",
                                style: FrontEndConfig.subHeadingTextStyle,
                              ),
                            ],
                          ),

                          0.02.height(context),

                          Text(
                            AppStrings.historicalBackgroundHeadingTxt.tr,
                            style: FrontEndConfig.headingTextStyle,
                          ),

                          0.02.height(context),

                          _buildDescriptionText(
                              data.title ?? "", data.description ?? ""),
                          0.02.height(context),
                          _buildDescriptionText(
                              data.title ?? "", data.description ?? ""),
                          0.02.height(context),
                          _buildDescriptionText(
                              data.title ?? "", data.description ?? ""),
                        ],
                      ),
                    ),

                    0.02.height(context),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── FIX 1: FAB opens Google Maps ────────────────────────────────────────
        floatingActionButton: GestureDetector(
          onTap: _openGoogleMaps,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xffC89C18),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                AssetConstant.navigationArrow,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }

  Widget _buildDescriptionText(String title, String description) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: AppStrings.richTextThePrefixTxt.tr,
              style: FrontEndConfig.subHeadingTextStyle),
          TextSpan(
            text: " $title",
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: ", $description",
            style: FrontEndConfig.subHeadingTextStyle,
          ),
        ],
      ),
    );
  }

  // ── FIX 2: Dua bottom sheet occupies full screen height ─────────────────────
  void _showDuaBottomSheet(BuildContext context, String? dua) {
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(bottom: 25 + bottomPadding, left: 16, right: 16),
            child: MyContainer(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: FrontEndConfig.btnBorderColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: MyContainer(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FrontEndConfig.backgroundColor,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            AssetConstant.bottomSheetDesgin,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: 89,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                0.02.height(context),
                                Center(
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor:
                                    const Color(0xffC89C18).withOpacity(0.3),
                                    child: Image.asset(
                                      AssetConstant.pray,
                                      height: 42,
                                    ),
                                  ),
                                ),
                                0.02.height(context),
                                Center(
                                  child: Text(
                                    AppStrings.recommendedDuaHeadingTxt.tr,
                                    style: FrontEndConfig.mainTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                0.02.height(context),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    dua ??
                                        "رَبَّنَا لَا تُزِغۡ قُلُوبَنَا بَعۡدَ إِذۡ هَدَيۡتَنَا وَهَبۡ لَنَا مِن لَّدُنكَ رَحۡمَةًۚ إِنَّكَ أَنتَ ٱلۡوَهَّابُ",
                                    style: TextStyle(
                                      fontFamily:
                                      GoogleFonts.amiriQuran().fontFamily,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                0.04.height(context),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: GestureDetector(
                                      onTap: () => NavigatorHelper.pop(context),
                                      child: Text(
                                        AppStrings.closeBtnTxt.tr,
                                        textAlign: TextAlign.center,
                                        style:
                                        FrontEndConfig.headingTextStyle.copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                          decorationThickness: 2,
                                          height: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDividerLinear() {
    return Container(
      height: 19,
      width: 0.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff999999), Color(0xffFFFFFF), Color(0xff999999)],
        ),
      ),
    );
  }
}