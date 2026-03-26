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

          // Show mini player if playing or paused AND bottom sheet is not open
          if ((state == PlayerState.playing || state == PlayerState.paused) && !_bottomSheetOpen) {
            _miniPlayerVisible = true;
          }

          // Hide mini player only if stopped or completed
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

  Future<void> _openGoogleMaps() async {
    final lat = widget.data.lat;
    final lng = widget.data.lng;

    Uri uri;
    if (lat != null && lng != null) {
      uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    } else {
      final query = Uri.encodeComponent(widget.data.title ?? 'Ziarat');
      uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$query');
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
                content:
                Text('${AppStrings.failedToPlayAudioTxt.tr}: $e')),
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
    final minutes =
    d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
    d.inSeconds.remainder(60).toString().padLeft(2, '0');
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
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 6),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.data.title ?? '',
                                style: FrontEndConfig
                                    .headingTextStyle
                                    .copyWith(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              SliderTheme(
                                data:
                                SliderTheme.of(context).copyWith(
                                  activeTrackColor:
                                  const Color(0xffC89C18),
                                  inactiveTrackColor: Colors.white24,
                                  thumbColor:
                                  const Color(0xffC89C18),
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
                                        ? _duration.inSeconds
                                        .toDouble()
                                        : 1,
                                    onChanged: (val) async {
                                      await _audioPlayer.seek(
                                          Duration(
                                              seconds: val.toInt()));
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
                            setState(
                                    () => _miniPlayerVisible = false);
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
    // Track that bottom sheet is open and capture current playing state
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
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 25),
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
                            padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 10,
                                bottom: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 89,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                CircleAvatar(
                                  backgroundColor: const Color(0xffC89C18)
                                      .withOpacity(0.3),
                                  radius: 28,
                                  child: Image.asset(
                                    AssetConstant.speaker,
                                    width: 28,
                                    height: 28,
                                    color: const Color(0xffC89C18),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                Text(
                                  widget.data.title ?? '',
                                  style: FrontEndConfig.mainTextStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Audio Guide',
                                  style:
                                  FrontEndConfig.subHeadingTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),

                                SliderTheme(
                                  data:
                                  SliderTheme.of(context).copyWith(
                                    activeTrackColor:
                                    const Color(0xffC89C18),
                                    inactiveTrackColor: Colors.white24,
                                    thumbColor:
                                    const Color(0xffC89C18),
                                    overlayColor: const Color(0xffC89C18)
                                        .withOpacity(0.2),
                                    trackHeight: 3,
                                    thumbShape:
                                    const RoundSliderThumbShape(
                                        enabledThumbRadius: 6),
                                  ),
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
                                          Duration(
                                              seconds: val.toInt()));
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_formatDuration(_position),
                                          style: FrontEndConfig
                                              .subHeadingTextStyle),
                                      Text(_formatDuration(_duration),
                                          style: FrontEndConfig
                                              .subHeadingTextStyle),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text('Speed:',
                                        style: FrontEndConfig
                                            .subHeadingTextStyle),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: _speedOptions
                                              .map((speed) {
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
                                                margin: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 3),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 9,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(
                                                      0xffC89C18)
                                                      : Colors.white10,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(20),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? const Color(
                                                        0xffC89C18)
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
                                                        : FontWeight
                                                        .normal,
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
                                  onTap: () =>
                                      NavigatorHelper.pop(context),
                                  child: Text(
                                    AppStrings.closeBottomSheetBtnTxt.tr,
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
      // When bottom sheet is dismissed, mark it as closed
      if (mounted) {
        setState(() {
          _bottomSheetOpen = false;
          // Show mini player only if audio is still playing
          if (_isPlaying) {
            _miniPlayerVisible = true;
          } else {
            _miniPlayerVisible = false;
          }
        });
      }
    });
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
                              SizedBox(
                                height: 380,
                                width: double.infinity,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: images.length,
                                  onPageChanged: (index) {
                                    setState(
                                            () => currentIndex = index);
                                  },
                                  itemBuilder: (context, index) {
                                    final img = images[index];
                                    return img.startsWith('http')
                                        ? Image.network(
                                      img,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) =>
                                          Image.asset(
                                            AssetConstant.masjid,
                                            fit: BoxFit.cover,
                                          ),
                                    )
                                        : Image.asset(img,
                                        fit: BoxFit.cover);
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
                                          setState(() =>
                                          currentIndex = index);
                                          _pageController.animateToPage(
                                            index,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                              const Color(0xffA0832C),
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            child: img.startsWith('http')
                                                ? Image.network(
                                              img,
                                              width: 85,
                                              height: 75,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_,
                                                  __,
                                                  ___) =>
                                                  Image.asset(
                                                    AssetConstant
                                                        .masjid,
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

                              Positioned(
                                top: 25,
                                left: isRtl ? null : 20,
                                right: isRtl ? 20 : null,
                                child: GestureDetector(
                                  onTap: () =>
                                      NavigatorHelper.pop(context),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
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
                                            color: FrontEndConfig
                                                .listTileColor,
                                            borderRadius:
                                            BorderRadius.circular(
                                                100),
                                          ),
                                          child: Center(
                                            child: Text(
                                              data.type ?? "",
                                              style: FrontEndConfig
                                                  .btnTextStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    MyContainer(
                                      height: 34,
                                      width: 89,
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
                                            color: FrontEndConfig
                                                .listTileColor,
                                            borderRadius:
                                            BorderRadius.circular(
                                                100),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
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
                                              GestureDetector(
                                                onTap: () =>
                                                    _showDuaBottomSheet(
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
                                  style: FrontEndConfig
                                      .languageHeadingTextStyle,
                                ),

                                0.02.height(context),

                                Row(
                                  children: [
                                    Image.asset(AssetConstant.location,
                                        width: 18),
                                    0.02.width(context),
                                    Text(
                                      data.type ?? "",
                                      style: FrontEndConfig
                                          .subHeadingTextStyle,
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

                                _buildDescriptionText(data.title ?? "",
                                    data.description ?? ""),
                                0.02.height(context),
                                _buildDescriptionText(data.title ?? "",
                                    data.description ?? ""),
                                0.02.height(context),
                                _buildDescriptionText(data.title ?? "",
                                    data.description ?? ""),
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
        floatingActionButtonLocation:
        FloatingActionButtonLocation.startFloat,
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

  void _showDuaBottomSheet(BuildContext context, String? dua) {
    final double bottomPadding =
        MediaQuery.of(context).viewPadding.bottom;

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
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
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
                                Center(
                                  child: Text(
                                    AppStrings
                                        .recommendedDuaHeadingTxt.tr,
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
                                      fontFamily: GoogleFonts.amiriQuran()
                                          .fontFamily,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                0.04.height(context),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0),
                                    child: GestureDetector(
                                      onTap: () =>
                                          NavigatorHelper.pop(context),
                                      child: Text(
                                        AppStrings.closeBtnTxt.tr,
                                        textAlign: TextAlign.center,
                                        style: FrontEndConfig
                                            .headingTextStyle
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
          colors: [
            Color(0xff999999),
            Color(0xffFFFFFF),
            Color(0xff999999)
          ],
        ),
      ),
    );
  }
}