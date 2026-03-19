import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ziarat_app/application/navigation_helper.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import '../../../application/sim_provider_bloc/sim_provider_bloc.dart';
import '../../../infrastructure/models/sim_provider.dart';
import '../../../injection_container.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';
import 'layout/package_details_body.dart';

class NetworkProvider extends StatelessWidget {
  const NetworkProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SimProviderBloc>()..add(const GetSimProviderEvent()),
      child: const _NetworkProviderView(),
    );
  }
}

class _NetworkProviderView extends StatelessWidget {
  const _NetworkProviderView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),
          Positioned.fill(
            child: Image.asset(AssetConstant.backgroundimage, fit: BoxFit.cover),
          ),
          SafeArea(
            child: BlocBuilder<SimProviderBloc, SimProviderState>(
              builder: (context, state) {
                if (state is SimProviderInitial || state is SimProviderLoading) {
                  return _NetworkProviderShimmer();
                }

                if (state is SimProviderLoaded) {
                  return _NetworkProviderContent(
                    providers: state.model.data ?? [],
                  );
                }

                if (state is SimProviderFailed) {
                  return Center(
                    child: Text(state.message,
                        style: FrontEndConfig.headingTextStyle),
                  );
                }

                return Center(
                  child: Text(AppStrings.genericSomethingWentWrongTxt.tr,
                      style: FrontEndConfig.headingTextStyle),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkProviderContent extends StatelessWidget {
  final List<SimProviderModel> providers;

  const _NetworkProviderContent({required this.providers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12.0),
          child: CommonAppBar(
            title: AppStrings.networkProvidersAppBarTitleTxt.tr,
            actionIcon: AssetConstant.helpIcon,
            icon: Icons.arrow_back,
            onLeadingTap: () => NavigatorHelper.pop(context),
            onActionTap: () => _buildShowInfoSheet(context),
          ),
        ),
        0.02.height(context),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: MyContainer(
            decoration: BoxDecoration(
              gradient: FrontEndConfig.btnBorderColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: MyContainer(
                decoration: BoxDecoration(
                  color: FrontEndConfig.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 230,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(AssetConstant.sim,
                          fit: BoxFit.cover, height: 230),
                    ),
                    // ✅ Gradient covers the entire image without gaps
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                const Color(0xff354A64).withOpacity(0.3),
                                const Color(0xff354A64).withOpacity(0.5),
                                const Color(0xff354A64),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(AppStrings.simInfoHeadingTxt.tr,
                              style: FrontEndConfig.languageHeadingTextStyle),
                          0.01.height(context),
                          Text(
                            AppStrings.simInfoDescriptionTxt.tr,
                            textAlign: TextAlign.center,
                            style: FrontEndConfig.bodyTextStyle
                                .copyWith(fontWeight: FontWeight.w500),
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
        0.02.height(context),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(AppStrings.listOfProvidersHeadingTxt.tr,
                style: FrontEndConfig.mainTextStyle),
          ),
        ),
        0.01.height(context),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final provider = providers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: MyContainer(
                    height: 85,
                    decoration: BoxDecoration(
                      gradient: FrontEndConfig.btnBorderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: MyContainer(
                        onTap: () {
                          NavigatorHelper.push(
                            context,
                            PackageDetailsViewBody(provider: provider),
                          );
                        },
                        decoration: BoxDecoration(
                          color: FrontEndConfig.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  provider.image ?? '',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    AssetConstant.sim1,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(provider.title ?? '',
                                        style: FrontEndConfig.headingTextStyle),
                                    Row(
                                      children: [
                                        Text(AppStrings.helplineLabelTxt.tr,
                                            style: FrontEndConfig.headingTextStyle),
                                        0.01.width(context),
                                        Text(provider.helplineNumber ?? '',
                                            style: FrontEndConfig.subHeadingTextStyle),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.only(
                                              end: 20.0),
                                          child: Transform.scale(
                                            scaleX: Directionality.of(context) ==
                                                TextDirection.rtl
                                                ? -1
                                                : 1,
                                            child: Image.asset(
                                              AssetConstant.arrowForwardIcon,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(AssetConstant.signal,
                                            width: 16,
                                            height: 16,
                                            color: Colors.green),
                                        0.01.width(context),
                                        Text(provider.description ?? '',
                                            style: FrontEndConfig.subHeadingTextStyle),
                                      ],
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _buildShowInfoSheet(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
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
                  height: MediaQuery.of(context).size.height * 0.43,
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
                        // Background image — must not use Positioned.fill
                        // so it sizes to the content, not the screen
                        Positioned.fill(
                          child: Image.asset(AssetConstant.bottomSheetDesgin,
                              fit: BoxFit.cover),
                        ),
                        // ── Content: SingleChildScrollView wraps a Column ──
                        // Scrolls only when content exceeds available space
                        SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                  radius: 30,
                                  backgroundColor:
                                  const Color(0xffC89C18).withOpacity(0.3),
                                  backgroundImage:
                                  AssetImage(AssetConstant.ellipseIcon),
                                  child: Image.asset(AssetConstant.announcement,
                                      width: 34, height: 34),
                                ),
                                0.02.height(context),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      AppStrings.requirementsForSimHeadingTxt.tr,
                                      textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                                      style: FrontEndConfig.mainTextStyle),
                                ),
                                0.02.height(context),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      AppStrings.requirementPassportValidityTxt.tr,
                                      textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                                      style: FrontEndConfig.bodyTextStyle),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      AppStrings
                                          .requirementFingerprintVerificationTxt.tr,
                                      textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                                      style: FrontEndConfig.bodyTextStyle),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      AppStrings.requirementUsuallyActiveTxt.tr,
                                      textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                                      style: FrontEndConfig.bodyTextStyle),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      AppStrings.requirementGetSimsJeddahTxt.tr,
                                      textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                                      style: FrontEndConfig.bodyTextStyle),
                                ),
                                0.01.height(context),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    AppStrings.closeBottomSheetBtnTxt.tr,
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
}

class _NetworkProviderShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12.0),
          child: CommonAppBar(
            title: AppStrings.networkProvidersAppBarTitleTxt.tr,
            actionIcon: AssetConstant.helpIcon,
            icon: Icons.arrow_back,
            onLeadingTap: () => NavigatorHelper.pop(context),
          ),
        ),
        0.02.height(context),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.22),
            highlightColor: Colors.white.withOpacity(0.48),
            child: Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.26)),
              ),
            ),
          ),
        ),
        0.02.height(context),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.22),
              highlightColor: Colors.white.withOpacity(0.48),
              child: Container(
                height: 14,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.26),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        0.01.height(context),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.white.withOpacity(0.22),
                    highlightColor: Colors.white.withOpacity(0.48),
                    child: Container(
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(8),
                        border:
                        Border.all(color: Colors.white.withOpacity(0.26)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.32),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _bar(width: 120, height: 13),
                                  const SizedBox(height: 8),
                                  _bar(width: 160, height: 11),
                                  const SizedBox(height: 6),
                                  _bar(width: 100, height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.32),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}