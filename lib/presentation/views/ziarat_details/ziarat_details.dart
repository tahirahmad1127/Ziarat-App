import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
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

  /// Audio
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    images = (widget.data.images != null && widget.data.images!.isNotEmpty)
        ? widget.data.images!
        : [AssetConstant.masjid, AssetConstant.masjid2, AssetConstant.masjid3];

    _audioPlayer.onPlayerStateChanged.listen((state) {
      print("PLAYER STATE CHANGED: $state"); // 👈 add this
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          _isLoading = false;
        });
      }
    });

    /// Also listen for errors
    _audioPlayer.onLog.listen((msg) {
      print("AUDIO LOG: $msg"); // 👈 add this
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    final audioUrl = widget.data.audioGuide;
    print("AUDIO URL: $audioUrl"); // 👈 check if URL is not null
    print("IS PLAYING: $_isPlaying");

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
        print("AUDIO STARTED");
      } catch (e) {
        print("AUDIO ERROR: $e"); // 👈 check for errors
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.failedToPlayAudioTxt.tr}: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),
          Positioned.fill(
            child: Image.asset(AssetConstant.backgroundimage, fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Image Slider with Back Button & Thumbnails
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
                        padding: const EdgeInsets.only(top: 278.0, left: 20, right: 20),
                        child: SizedBox(
                          height: 70,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final img = images[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() => currentIndex = index);
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
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

                      Positioned(
                        top: 25,
                        left: 20,
                        child: GestureDetector(
                          onTap: () => NavigatorHelper.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xff243243),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white),
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
                            /// Type Badge
                            MyContainer(
                              height: 34,
                              decoration: BoxDecoration(
                                gradient: FrontEndConfig.btnBorderColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: MyContainer(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
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

                            /// Speaker + Dua Button
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
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      /// Speaker button — play/pause/loading
                                      GestureDetector(
                                        onTap: _toggleAudio,
                                        child: _isLoading
                                            ? const SizedBox(
                                          width: 21,
                                          height: 21,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                            : Image.asset(
                                          _isPlaying
                                              ? AssetConstant.speaker // swap to pause icon if you have one
                                              : AssetConstant.speaker,
                                          width: 21,
                                          height: 21,
                                          /// Golden tint when playing
                                          color: _isPlaying
                                              ? const Color(0xffC89C18)
                                              : FrontEndConfig.listTileIconColor,
                                        ),
                                      ),
                                      _buildDividerLinear(),
                                      GestureDetector(
                                        onTap: () => _showDuaBottomSheet(context, data.dua),
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

                        _buildDescriptionText(data.title ?? "", data.description ?? ""),
                        0.02.height(context),
                        _buildDescriptionText(data.title ?? "", data.description ?? ""),
                        0.02.height(context),
                        _buildDescriptionText(data.title ?? "", data.description ?? ""),
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
      floatingActionButton: CircleAvatar(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDescriptionText(String title, String description) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: AppStrings.richTextThePrefixTxt.tr, style: FrontEndConfig.subHeadingTextStyle),
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
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                height: MediaQuery.of(context).size.height * 0.38,
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
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 89,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              0.02.height(context),
                              CircleAvatar(
                                radius: 32,
                                backgroundColor:
                                const Color(0xffC89C18).withOpacity(0.3),
                                child: Image.asset(
                                  AssetConstant.pray,
                                  height: 42,
                                ),
                              ),
                              0.02.height(context),
                              Text(
                                AppStrings.recommendedDuaHeadingTxt.tr,
                                style: FrontEndConfig.mainTextStyle,
                              ),
                              0.02.height(context),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 10,
                                ),
                                child: Text(
                                  dua ?? "رَبَّنَا لَا تُزِغۡ قُلُوبَنَا بَعۡدَ إِذۡ هَدَيۡتَنَا وَهَبۡ لَنَا مِن لَّدُنكَ رَحۡمَةًۚ إِنَّكَ أَنتَ ٱلۡوَهَّابُ",
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.amiriQuran().fontFamily,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              0.04.height(context),
                              GestureDetector(
                                onTap: () => NavigatorHelper.pop(context),
                                child: Text(
                                  AppStrings.closeBtnTxt.tr,
                                  style: FrontEndConfig.headingTextStyle.copyWith(
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