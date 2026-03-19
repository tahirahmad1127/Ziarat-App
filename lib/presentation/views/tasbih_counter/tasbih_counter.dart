import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../application/counter_bloc/counter_bloc.dart';
import '../../../application/counter_bloc/counter_event.dart';
import '../../../application/counter_bloc/counter_state.dart';
import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../elements/app_bar.dart';
import '../../constants/app_strings.dart';

class TasbihCounter extends StatelessWidget {
  const TasbihCounter({super.key});

  void _showResetDialog(BuildContext context) {
    showDialog(
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
                /// Icon
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xffC89C18).withOpacity(0.2),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xffC89C18),
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                /// Title
                Text(
                  AppStrings.resetCounterTitleTxt.tr,
                  style: FrontEndConfig.headingTextStyle,
                ),

                const SizedBox(height: 10),

                /// Subtitle
                Text(
                  AppStrings.resetCounterSubtitleTxt.tr,
                  textAlign: TextAlign.center,
                  style: FrontEndConfig.subHeadingTextStyle,
                ),

                const SizedBox(height: 24),

                /// Buttons
                Row(
                  children: [
                    /// Cancel
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
                            AppStrings.cancelBtnLabelTxt.tr,
                            style: FrontEndConfig.subHeadingTextStyle,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Yes, Reset
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
                            context
                                .read<CounterBloc>()
                                .add(const CounterResetEvent());
                          },
                          child: Text(
                            AppStrings.yesResetBtnLabelTxt.tr,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),

          Positioned.fill(
            child: Image.asset(
              AssetConstant.backgroundimage,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                /// AppBar
                Padding(
                  padding: const EdgeInsets.only(right: 11.0),
                  child: CommonAppBar(
                    title: AppStrings.tasbihAppBarTitleTxt.tr,
                    showLeading: false,
                    color: FrontEndConfig.iconColor,
                    actionIconSize: 20,
                    actionIcon: AssetConstant.restartIcon,
                    onActionTap: () => _showResetDialog(context),
                  ),
                ),

                /// Tasbih + Counter
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      context
                          .read<CounterBloc>()
                          .add(const CounterIncEvent());
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              AssetConstant.tasbih,
                              height: 445,
                              width: 398,
                            ),
                          ),

                          BlocBuilder<CounterBloc, CounterState>(
                            builder: (context, state) {
                              int count = 0;
                              if (state is CounterInitialState) {
                                count = state.count;
                              } else if (state is CounterIncState) {
                                count = state.incCount;
                              }

                              return Align(
                                alignment: const Alignment(0, -0.20),
                                child: Text(
                                  count.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize:
                                    MediaQuery.of(context).size.width *
                                        0.25,
                                    fontWeight: FontWeight.w600,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: [
                                          Color(0xFFC89C18),
                                          Color(0xFFE9C41E),
                                        ],
                                      ).createShader(
                                        Rect.fromLTWH(
                                          0,
                                          0,
                                          MediaQuery.of(context).size.width,
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                        ),
                                      ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Quran Ayah
                Padding(
                  padding: const EdgeInsets.only(bottom: 25, right: 20, left: 20),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.tasbihAyahArabicTxt.tr,
                        style: GoogleFonts.amiriQuran(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: FrontEndConfig.textColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        AppStrings.tasbihAyahTranslationTxt.tr,
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          color: FrontEndConfig.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}