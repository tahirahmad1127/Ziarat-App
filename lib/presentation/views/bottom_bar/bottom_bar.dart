import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/constants/app_strings.dart';
import 'package:ziarat_app/presentation/views/home/home.dart';

import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../elements/ad_widget.dart';
import '../settings/settings.dart';
import '../tasbih_counter/tasbih_counter.dart';
import '../umrah_guide/guide.dart';
import '../ziarat/layout/body.dart';
import '../ziarat/ziarat.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Add delay to ensure UI is fully rendered before showing dialog
    Future.delayed(const Duration(seconds: 1), () {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    final newVersion = NewVersionPlus(
      iOSId: 'com.devspace.studies',
      androidId: 'com.devspace.studies',
    );
    advancedStatusCheck(newVersion);
  }

  Future<void> advancedStatusCheck(NewVersionPlus newVersion) async {
    // ── FOR TESTING: This will show a fake update dialog ──
    try {
       VersionStatus status = VersionStatus(
        localVersion: '1.0.0',
        storeVersion: '2.0.0',
        appStoreLink: 'https://play.google.com/store/apps/details?id=com.devspace.studies',
        releaseNotes: 'Test update - new features available',
      );

      if (status.storeVersion.compareTo(status.localVersion) > 0 && mounted) {
        debugPrint('Update available! Local: ${status.localVersion}, Store: ${status.storeVersion}');
        _showUpdateDialog();
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  Future<void> _openPlayStore() async {
    final String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.devspace.studies';

    try {
      if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
        await launchUrl(
          Uri.parse(playStoreUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Could not launch Play Store');
      }
    } catch (e) {
      debugPrint('Error opening Play Store: $e');
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: FrontEndConfig.btnBorderColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: FrontEndConfig.backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Icon
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xffC89C18).withOpacity(0.2),
                  child: const Icon(
                    Icons.system_update_rounded,
                    color: Color(0xffC89C18),
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                /// Title
                Text(
                  AppStrings.updateAvailableTitleTxt.tr,
                  style: FrontEndConfig.headingTextStyle,
                ),

                const SizedBox(height: 10),

                /// Subtitle
                Text(
                  AppStrings.updateAvailableSubtitleTxt.tr,
                  textAlign: TextAlign.center,
                  style: FrontEndConfig.subHeadingTextStyle,
                ),

                const SizedBox(height: 24),

                /// Buttons
                Row(
                  children: [
                    /// Later
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: FrontEndConfig.btnBorderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: FrontEndConfig.backgroundColor,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            AppStrings.updateLaterBtnTxt.tr,
                            style: FrontEndConfig.subHeadingTextStyle,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Update Now
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: FrontEndConfig.btnBorderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffC89C18),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            // Open Play Store
                            _openPlayStore();
                          },
                          child: Text(
                            AppStrings.updateNowBtnTxt.tr,
                            style: FrontEndConfig.bodyTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: FrontEndConfig.fontSize(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showExitDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: FrontEndConfig.btnBorderColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: FrontEndConfig.backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xffC89C18).withOpacity(0.2),
                  child: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Color(0xffC89C18),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.exitAppTitleTxt.tr,
                  style: FrontEndConfig.headingTextStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.exitAppSubtitleTxt.tr,
                  textAlign: TextAlign.center,
                  style: FrontEndConfig.subHeadingTextStyle,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: FrontEndConfig.btnBorderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 1),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: FrontEndConfig.backgroundColor,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            AppStrings.stayBtnLabelTxt.tr,
                            style: FrontEndConfig.subHeadingTextStyle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: FrontEndConfig.btnBorderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 1),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffC89C18),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await SystemNavigator.pop();
                          },
                          child: Text(
                            AppStrings.exitBtnLabelTxt.tr,
                            style: FrontEndConfig.bodyTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (selectedIndex != 0) {
      setState(() => selectedIndex = 0);
      return false;
    }
    await _showExitDialog();
    return false;
  }

  final List<Map<String, String>> navItems = [
    {
      'selected': AssetConstant.kHomeSelected,
      'unselected': AssetConstant.kHomeUnselected,
    },
    {
      'selected': AssetConstant.kZiaratSelected,
      'unselected': AssetConstant.kZiaratUnselected,
    },
    {
      'selected': AssetConstant.kTasbihSelected,
      'unselected': AssetConstant.kTasbihUnselected,
    },
    {
      'selected': AssetConstant.kUmrahSelected,
      'unselected': AssetConstant.kUmrahUnselected,
    },
    {
      'selected': AssetConstant.kSettingSelected,
      'unselected': AssetConstant.kSettingUnselected,
    },
  ];

  final List<Widget> screens = const [
    Home(),
    ZiaratViewBody(),
    TasbihCounter(),
    Guide(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      // ── Outer Column: stacks the full-screen scaffold + the pinned ad ──────
      child: Column(
        children: [
          // ── Scaffold takes all space above the ad ─────────────────────────
          Expanded(
            child: Scaffold(
              body: screens[selectedIndex],
              bottomNavigationBar: ColoredBox(
                color: FrontEndConfig.backgroundColor,
                child: SafeArea(
                  // top: false so the nav bar doesn't add unnecessary top padding
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, bottom: 10, top: 5),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: FrontEndConfig.btnBorderColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: FrontEndConfig.listTileColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                navItems.length,
                                    (index) => GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedIndex = index),
                                  child: SizedBox(
                                    width: 45,
                                    height: 58,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        // Top active indicator
                                        AnimatedContainer(
                                          duration:
                                          const Duration(milliseconds: 250),
                                          curve: Curves.easeInOut,
                                          height: 3,
                                          width: selectedIndex == index ? 15 : 0,
                                          decoration: BoxDecoration(
                                            gradient: selectedIndex == index
                                                ? FrontEndConfig.btnBorderColor
                                                : null,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(2),
                                              bottomRight: Radius.circular(2),
                                            ),
                                          ),
                                        ),
                                        // Nav icon
                                        Expanded(
                                          child: Center(
                                            child: _buildNavIcon(index),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Banner ad — pinned below the nav bar on every tab ─────────────
          // Lives outside the Scaffold entirely so nothing can overlap it.
          // Automatically collapses to zero height until the ad loads.
          // SafeArea handles the home indicator bar on notched devices.
          ColoredBox(
            color: FrontEndConfig.backgroundColor,
            child: SafeArea(
              top: false,
              child: ColoredBox(
                color: FrontEndConfig.backgroundColor,
                child: const BannerAdWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(int index) {
    final isSelected = selectedIndex == index;
    final isHome = index == 0;

    if (!isSelected && isHome) {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        child: Image.asset(
          navItems[index]['unselected']!,
          width: 24,
          height: 24,
        ),
      );
    }

    if (isSelected) {
      return ShaderMask(
        shaderCallback: (bounds) => FrontEndConfig.btnBorderColor.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        blendMode: BlendMode.srcIn,
        child: Image.asset(
          navItems[index]['selected']!,
          width: 24,
          height: 24,
        ),
      );
    }

    return Image.asset(
      navItems[index]['unselected']!,
      width: 24,
      height: 24,
    );
  }
}