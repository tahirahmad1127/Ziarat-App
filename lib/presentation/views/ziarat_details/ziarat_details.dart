import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';
import 'package:ziarat_app/infrastructure/models/ziarat_details.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
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
  bool _miniPlayerVisible = false;
  bool _bottomSheetOpen = false;
  bool _wasPlayingWhenSheetOpened = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  static const List<double> _speedOptions = [0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

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

          if ((state == PlayerState.playing || state == PlayerState.paused) &&
              !_bottomSheetOpen) {
            _miniPlayerVisible = true;
          }

          if (state == PlayerState.stopped || state == PlayerState.completed) {
            _miniPlayerVisible = false;
          }
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

  // ─── Parse HTML → list of plain-text bullet strings ────────────────────────
  /// Handles both <p>...</p> (en/ur) and <ul><li>...</li></ul> (ar) formats
  /// returned by the API, stripping all inner HTML tags to plain text.
  List<String> _parseImportantPointsHtml(String? html) {
    if (html == null || html.trim().isEmpty) return [];

    final document = html_parser.parse(html);
    final points = <String>[];

    // First try <li> elements (Arabic format uses <ul><li>)
    final liElements = document.querySelectorAll('li');
    if (liElements.isNotEmpty) {
      for (final li in liElements) {
        final text = li.text.trim();
        if (text.isNotEmpty) points.add(text);
      }
      return points;
    }

    // Fallback: <p> elements (English / Urdu format uses <p>point text</p>)
    final pElements = document.querySelectorAll('p');
    for (final p in pElements) {
      final text = p.text.trim();
      if (text.isNotEmpty) points.add(text);
    }

    return points;
  }

  Future<void> _openGoogleMaps() async {
    final lat = widget.data.lat;
    final lng = widget.data.lng;

    Uri uri;
    if (lat != null && lng != null) {
      uri =
          Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    } else {
      final query = Uri.encodeComponent(widget.data.title ?? 'Ziarat');
      uri =
          Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
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
        await _audioPlayer.setPlaybackRate(_playbackSpeed);
      } catch (e) {
        debugPrint("AUDIO ERROR: $e");
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${AppStrings.failedToPlayAudioTxt.tr}: $e')),
          );
          return;
        }
      }
    }

    if (mounted) {
      _showAudioBottomSheet();
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _setSpeed(double speed) async {
    setState(() => _playbackSpeed = speed);
    await _audioPlayer.setPlaybackRate(speed);
  }

  Widget _buildPlayPauseButton({
    required bool isPlaying,
    required bool isLoading,
    required VoidCallback onTap,
    double size = 56,
    double iconSize = 30,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: const Color(0xffC89C18),
            width: 2,
          ),
        ),
        child: isLoading
            ? Padding(
          padding: EdgeInsets.all(size * 0.25),
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xffC89C18),
          ),
        )
            : Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: const Color(0xffC89C18),
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _miniPlayerVisible
            ? GestureDetector(
          onTap: _showAudioBottomSheet,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: MyContainer(
              decoration: BoxDecoration(
                gradient: FrontEndConfig.btnBorderColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: MyContainer(
                  decoration: BoxDecoration(
                    color: FrontEndConfig.listTileColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        _buildPlayPauseButton(
                          isPlaying: _isPlaying,
                          isLoading: _isLoading,
                          size: 32,
                          iconSize: 18,
                          onTap: () async {
                            if (_isPlaying) {
                              await _audioPlayer.pause();
                            } else {
                              await _audioPlayer.resume();
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.data.title ?? '',
                                style: FrontEndConfig.headingTextStyle
                                    .copyWith(fontSize: FrontEndConfig.fontSize(12)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor:
                                  const Color(0xffC89C18),
                                  inactiveTrackColor: Colors.white24,
                                  thumbColor: const Color(0xffC89C18),
                                  trackHeight: 2,
                                  thumbShape:
                                  const RoundSliderThumbShape(
                                      enabledThumbRadius: 4),
                                  overlayShape:
                                  SliderComponentShape.noOverlay,
                                ),
                                child: SizedBox(
                                  height: 16,
                                  child: Slider(
                                    value: _duration.inSeconds > 0
                                        ? _position.inSeconds
                                        .toDouble()
                                        .clamp(
                                        0,
                                        _duration.inSeconds
                                            .toDouble())
                                        : 0,
                                    min: 0,
                                    max: _duration.inSeconds > 0
                                        ? _duration.inSeconds.toDouble()
                                        : 1,
                                    onChanged: (val) async {
                                      await _audioPlayer.seek(
                                          Duration(seconds: val.toInt()));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                          style: FrontEndConfig.subHeadingTextStyle
                              .copyWith(fontSize: 10),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            await _audioPlayer.stop();
                            setState(() => _miniPlayerVisible = false);
                          },
                          child: const Icon(Icons.close,
                              color: Colors.white54, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
            : const SizedBox(width: double.infinity, height: 0),
      ),
    );
  }

  void _showAudioBottomSheet() {
    setState(() {
      _bottomSheetOpen = true;
      _miniPlayerVisible = false;
      _wasPlayingWhenSheetOpened = _isPlaying;
    });

    showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
              child: MyContainer(
                decoration: BoxDecoration(
                  gradient: FrontEndConfig.btnBorderColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: MyContainer(
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
                      borderRadius: BorderRadius.circular(13),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              AssetConstant.bottomSheetDesgin,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                const SizedBox(height: 16),
                                Text(
                                  widget.data.title ?? '',
                                  style: FrontEndConfig.mainTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: const Color(0xffC89C18),
                                    inactiveTrackColor: Colors.white24,
                                    thumbColor: const Color(0xffC89C18),
                                    trackHeight: 3,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6),
                                    overlayShape:
                                    SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    value: _duration.inSeconds > 0
                                        ? _position.inSeconds
                                        .toDouble()
                                        .clamp(0,
                                        _duration.inSeconds.toDouble())
                                        : 0,
                                    min: 0,
                                    max: _duration.inSeconds > 0
                                        ? _duration.inSeconds.toDouble()
                                        : 1,
                                    onChanged: (val) async {
                                      await _audioPlayer.seek(
                                          Duration(seconds: val.toInt()));
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_formatDuration(_position),
                                          style:
                                          FrontEndConfig.subHeadingTextStyle),
                                      Text(_formatDuration(_duration),
                                          style:
                                          FrontEndConfig.subHeadingTextStyle),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final newPos = _position -
                                            const Duration(seconds: 10);
                                        await _audioPlayer.seek(
                                          newPos < Duration.zero
                                              ? Duration.zero
                                              : newPos,
                                        );
                                      },
                                      icon: const Icon(Icons.replay_10,
                                          color: Colors.white, size: 30),
                                    ),
                                    const SizedBox(width: 16),
                                    _buildPlayPauseButton(
                                      isPlaying: _isPlaying,
                                      isLoading: _isLoading,
                                      onTap: () async {
                                        if (_isPlaying) {
                                          await _audioPlayer.pause();
                                        } else {
                                          await _audioPlayer.resume();
                                        }
                                        setSheetState(() {});
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      onPressed: () async {
                                        final newPos = _position +
                                            const Duration(seconds: 10);
                                        await _audioPlayer.seek(
                                          newPos > _duration
                                              ? _duration
                                              : newPos,
                                        );
                                      },
                                      icon: const Icon(Icons.forward_10,
                                          color: Colors.white, size: 30),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Speed:',
                                        style:
                                        FrontEndConfig.subHeadingTextStyle),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children:
                                          _speedOptions.map((speed) {
                                            final isSelected =
                                                _playbackSpeed == speed;
                                            return GestureDetector(
                                              onTap: () async {
                                                await _setSpeed(speed);
                                                setSheetState(() {});
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                margin:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 3),
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 9,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xffC89C18)
                                                      : Colors.white10,
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? const Color(0xffC89C18)
                                                        : Colors.white24,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  speed == 1.0
                                                      ? '1×'
                                                      : '${speed}×',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () => NavigatorHelper.pop(context),
                                  child: Text(
                                    AppStrings.closeBottomSheetBtnTxt.tr,
                                    textAlign: TextAlign.center,
                                    style: FrontEndConfig.headingTextStyle
                                        .copyWith(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      decorationThickness: 2,
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    ).then((_) {
      if (mounted) {
        setState(() {
          _bottomSheetOpen = false;
          if (_isPlaying) {
            _miniPlayerVisible = true;
          } else {
            _miniPlayerVisible = false;
          }
        });
      }
    });
  }

  // ─── Dua Bottom Sheet ────────────────────────────────────────────────────────
  void _showDuaBottomSheet(
      BuildContext context, String? dua, String? zikar, String? nafalPrayer) {
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final langCode = Get.locale?.languageCode ?? 'en';
    final bool isRtl = langCode == 'ar' || langCode == 'ur';

    // ── Localised section headings ────────────────────────────────────────────
    String zikrHeading;
    String naflHeading;
    if (langCode == 'ur') {
      zikrHeading = 'ذکر';
      naflHeading = 'نفل';
    } else if (langCode == 'ar') {
      zikrHeading = 'الذكر';
      naflHeading = 'النافلة';
    } else {
      zikrHeading = 'Zikr';
      naflHeading = 'Nafl';
    }

    showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      builder: (context) {
        final double maxHeight = MediaQuery.of(context).size.height * 0.70;
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: 25 + bottomPadding, left: 16, right: 16),
            child: MyContainer(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: FrontEndConfig.btnBorderColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
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
                              child: Directionality(
                                textDirection:
                                isRtl ? TextDirection.rtl : TextDirection.ltr,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ── Drag handle ───────────────────────────
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

                                    // ── Icon ─────────────────────────────────
                                    Center(
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundColor:
                                        const Color(0xffC89C18)
                                            .withOpacity(0.3),
                                        child: Image.asset(
                                          AssetConstant.pray,
                                          height: 42,
                                        ),
                                      ),
                                    ),
                                    0.02.height(context),

                                    // ── Zikr Section ──────────────────────────
                                    Center(
                                      child: Text(
                                        zikrHeading,
                                        style: FrontEndConfig.mainTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    0.015.height(context),
                                    if (zikar != null && zikar.isNotEmpty)
                                      Text(
                                        zikar,
                                        style: FrontEndConfig.subHeadingTextStyle.copyWith(color: Colors.white),
                                        textAlign: isRtl
                                            ? TextAlign.right
                                            : TextAlign.left,
                                      )
                                    else
                                      const SizedBox.shrink(),

                                    // ── 10px gap ─────────────────────────────
                                    const SizedBox(height: 10),

                                    // ── Nafl Section ──────────────────────────
                                    Center(
                                      child: Text(
                                        naflHeading,
                                        style: FrontEndConfig.mainTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    0.015.height(context),
                                    if (nafalPrayer != null &&
                                        nafalPrayer.isNotEmpty)
                                      Text(
                                        nafalPrayer,
                                        style: FrontEndConfig.subHeadingTextStyle.copyWith(color: Colors.white),
                                        textAlign: isRtl
                                            ? TextAlign.right
                                            : TextAlign.left,
                                      )
                                    else
                                      const SizedBox.shrink(),

                                    0.04.height(context),

                                    // ── Close button ──────────────────────────
                                    Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              NavigatorHelper.pop(context),
                                          child: Text(
                                            AppStrings.closeBtnTxt.tr,
                                            textAlign: TextAlign.center,
                                            style: FrontEndConfig.headingTextStyle
                                                .copyWith(
                                              decoration:
                                              TextDecoration.underline,
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
                          ),
                        ],
                      ),
                    ),
                  ), // ConstrainedBox
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Important Points Bottom Sheet ──────────────────────────────────────────
  /// Renders dynamic importantPoints from the API as styled bullet rows.
  /// The `data.importantPoints` getter already returns the locale-correct
  /// string (en / ur / ar) based on the current GetX locale, so this works
  /// identically for both Makkah and Madina ziarat.
  void _showImportantPointsBottomSheet(
      BuildContext context, String? importantPoints) {
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final langCode = Get.locale?.languageCode ?? 'en';
    final bool isRtl = langCode == 'ar' || langCode == 'ur';

    // ── Heading label (localised) ─────────────────────────────────────────────
    String heading;
    if (langCode == 'ur') {
      heading = 'ضروری ہدایت';
    } else if (langCode == 'ar') {
      heading = 'نقاط مهمة';
    } else {
      heading = 'Important Points';
    }

    // ── Empty-state label (localised) ────────────────────────────────────────
    String emptyLabel;
    if (langCode == 'ur') {
      emptyLabel = 'کوئی ہدایت دستیاب نہیں';
    } else if (langCode == 'ar') {
      emptyLabel = 'لا توجد نقاط متاحة';
    } else {
      emptyLabel = 'No important points available.';
    }

    // ── Parse HTML → plain-text bullet list ──────────────────────────────────
    final List<String> bulletPoints =
    _parseImportantPointsHtml(importantPoints);

    showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      builder: (context) {
        final double maxHeight = MediaQuery.of(context).size.height * 0.70;
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: 25 + bottomPadding, left: 16, right: 16),
            child: MyContainer(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: FrontEndConfig.btnBorderColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
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
                          // ── Background design ──────────────────────────────
                          Positioned.fill(
                            child: Image.asset(
                              AssetConstant.bottomSheetDesgin,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // ── Scrollable content ─────────────────────────────
                          SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Directionality(
                                textDirection: isRtl
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Drag handle
                                    Center(
                                      child: Container(
                                        width: 89,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    0.02.height(context),

                                    // Eye icon avatar
                                    Center(
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundColor: const Color(0xffC89C18)
                                            .withOpacity(0.3),
                                        child: const Icon(
                                          Icons.visibility_outlined,
                                          color: Color(0xffC89C18),
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                    0.02.height(context),

                                    // Heading
                                    Center(
                                      child: Text(
                                        heading,
                                        style: FrontEndConfig.mainTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    0.02.height(context),

                                    // ── Bullet list or empty state ───────────
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 6),
                                      child: bulletPoints.isNotEmpty
                                          ? Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: bulletPoints
                                            .map((point) =>
                                            _buildBulletRow(
                                                point, isRtl))
                                            .toList(),
                                      )
                                          : Center(
                                        child: Text(
                                          emptyLabel,
                                          style: FrontEndConfig
                                              .subHeadingTextStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),

                                    0.04.height(context),

                                    // Close button
                                    Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              NavigatorHelper.pop(context),
                                          child: Text(
                                            AppStrings.closeBtnTxt.tr,
                                            textAlign: TextAlign.center,
                                            style: FrontEndConfig.headingTextStyle
                                                .copyWith(
                                              decoration:
                                              TextDecoration.underline,
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
                          ),
                        ],
                      ),
                    ),
                  ), // ConstrainedBox
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Renders a single bullet-point row.
  /// The golden bullet dot is always on the leading side regardless of RTL/LTR.
  Widget _buildBulletRow(String text, bool isRtl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Golden bullet dot
          Padding(
            padding: EdgeInsets.only(
              top: 5,
              left: isRtl ? 10 : 0,
              right: isRtl ? 0 : 10,
            ),
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffC89C18),
              ),
            ),
          ),

          // Point text
          Expanded(
            child: Text(
              text,
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: FrontEndConfig.subHeadingTextStyle,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
            ),
          ),
        ],
      ),
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
              child: Image.asset(AssetConstant.backgroundimage,
                  fit: BoxFit.cover),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildMiniPlayer(),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              // ── Image PageView ──────────────────────────
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
                                      errorBuilder: (_, __, ___) =>
                                          Image.asset(
                                            AssetConstant.masjid,
                                            fit: BoxFit.cover,
                                          ),
                                    )
                                        : Image.asset(img, fit: BoxFit.cover);
                                  },
                                ),
                              ),

                              // ── Bottom gradient ─────────────────────────
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

                              // ── Thumbnail strip ─────────────────────────
                              Padding(
                                padding: const EdgeInsets.only(top: 278.0),
                                child: SizedBox(
                                  height: 70,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: images.length + 2,
                                    separatorBuilder: (_, __) =>
                                    const SizedBox.shrink(),
                                    itemBuilder: (context, index) {
                                      if (index == 0 ||
                                          index == images.length + 1) {
                                        return const SizedBox(width: 20);
                                      }
                                      final img = images[index - 1];
                                      return Padding(
                                        padding:
                                        const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(
                                                    () => currentIndex = index);
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            child: img.startsWith('http')
                                                ? Image.network(
                                              img,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) =>
                                                  Image.asset(
                                                    AssetConstant.masjid,
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                            )
                                                : Image.asset(
                                              img,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // ── Back button ─────────────────────────────
                              Positioned(
                                top: 12,
                                left: isRtl ? null : 12,
                                right: isRtl ? 12 : null,
                                child: GestureDetector(
                                  onTap: () => NavigatorHelper.pop(context),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isRtl
                                          ? Icons.arrow_forward_ios
                                          : Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // ── Detail card ──────────────────────────────────
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: MyContainer(
                              decoration: BoxDecoration(
                                gradient: FrontEndConfig.btnBorderColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: MyContainer(
                                  decoration: BoxDecoration(
                                    color: FrontEndConfig.listTileColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            // ── Type badge ──────────────────────
                                            MyContainer(
                                              height: 34,
                                              decoration: BoxDecoration(
                                                gradient:
                                                FrontEndConfig.btnBorderColor,
                                                borderRadius:
                                                BorderRadius.circular(100),
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(1.0),
                                                child: MyContainer(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FrontEndConfig.listTileColor,
                                                    borderRadius:
                                                    BorderRadius.circular(100),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      data.type ?? "",
                                                      style:
                                                      FrontEndConfig.btnTextStyle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // ── Action buttons: Speaker | Dua | Eye ─
                                            MyContainer(
                                              height: 34,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                gradient:
                                                FrontEndConfig.btnBorderColor,
                                                borderRadius:
                                                BorderRadius.circular(100),
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(1.0),
                                                child: MyContainer(
                                                  decoration: BoxDecoration(
                                                    color:
                                                    FrontEndConfig.listTileColor,
                                                    borderRadius:
                                                    BorderRadius.circular(100),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      // Speaker / audio
                                                      GestureDetector(
                                                        onTap: _toggleAudio,
                                                        child: _isLoading
                                                            ? const SizedBox(
                                                          width: 21,
                                                          height: 21,
                                                          child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color:
                                                            Colors.white,
                                                          ),
                                                        )
                                                            : Image.asset(
                                                          AssetConstant
                                                              .speaker,
                                                          width: 21,
                                                          height: 21,
                                                          color: _isPlaying
                                                              ? const Color(
                                                              0xffC89C18)
                                                              : FrontEndConfig
                                                              .listTileIconColor,
                                                        ),
                                                      ),

                                                      _buildDividerLinear(),

                                                      // Dua / pray
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _showDuaBottomSheet(
                                                                context,
                                                                data.dua,
                                                                data.zikar,
                                                                data.nafalPrayer),
                                                        child: Image.asset(
                                                          AssetConstant.pray,
                                                          width: 22,
                                                          height: 22,
                                                        ),
                                                      ),

                                                      _buildDividerLinear(),

                                                      // Eye / important points
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _showImportantPointsBottomSheet(
                                                              context,
                                                              // data.importantPoints already returns
                                                              // the locale-correct HTML string from the API
                                                              data.importantPoints,
                                                            ),
                                                        child: const Icon(
                                                          Icons
                                                              .visibility_outlined,
                                                          color: Colors.white,
                                                          size: 21,
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
                                          style:
                                          FrontEndConfig.languageHeadingTextStyle,
                                        ),

                                        0.02.height(context),

                                        Row(
                                          children: [
                                            Image.asset(AssetConstant.location,
                                                width: 18),
                                            0.02.width(context),
                                            Text(
                                              data.type ?? "",
                                              style:
                                              FrontEndConfig.subHeadingTextStyle,
                                            ),
                                          ],
                                        ),

                                        0.02.height(context),

                                        Text(
                                          AppStrings
                                              .historicalBackgroundHeadingTxt.tr,
                                          style: FrontEndConfig.headingTextStyle,
                                        ),

                                        0.02.height(context),

                                        _buildDescriptionText(
                                            data.title ?? "",
                                            data.description ?? ""),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          0.02.height(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

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
    return Html(
      data: description,
      style: {
        "body": Style.fromTextStyle(
            FrontEndConfig.subHeadingTextStyle.copyWith(color: Colors.white)),
        "*": Style.fromTextStyle(
            FrontEndConfig.subHeadingTextStyle.copyWith(color: Colors.white)),
      },
    );
  }

  Widget _buildDividerLinear() {
    return Container(
      height: 19,
      width: 0.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff999999),
            Color(0xffFFFFFF),
            Color(0xff999999),
          ],
        ),
      ),
    );
  }
}