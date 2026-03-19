import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ziarat_app/application/sim_provider_bloc/sim_provider_bloc.dart';
import 'package:ziarat_app/infrastructure/models/sim_provider.dart';
import 'package:ziarat_app/infrastructure/services/sim_provider.dart';
import 'package:ziarat_app/presentation/views/sim/package_details.dart';
import '../../../../application/navigation_helper.dart';
import '../../../../configurations/frontend_config.dart';
import '../../../../injection_container.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/asset_constant.dart';
import '../../../elements/app_bar.dart';

class PackageDetailsViewBody extends StatelessWidget {
  final SimProviderModel provider;

  const PackageDetailsViewBody({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SimProviderBloc(sl<SimProviderRepositoryImp>())
        ..add(GetPackagesEvent(id: provider.id ?? '')),
      child: BlocBuilder<SimProviderBloc, SimProviderState>(
        builder: (context, state) {
          if (state is SimProviderInitial || state is SimProviderLoading) {
            return _PackageShimmer(provider: provider);
          } else if (state is PackagesLoaded) {
            return PackageDetails(
              provider: provider,
              packages: state.model.data ?? [],
            );
          } else if (state is SimProviderFailed) {
            return Center(child: Text(state.message));
          } else {
            return Center(
              child: Text(AppStrings.genericSomethingWentWrongTxt.tr),
            );
          }
        },
      ),
    );
  }
}

class _PackageShimmer extends StatelessWidget {
  final SimProviderModel provider;

  const _PackageShimmer({required this.provider});

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
            child: Column(
              children: [
                CommonAppBar(
                  title: provider.title ?? '',
                  icon: Icons.arrow_back,
                  color: FrontEndConfig.iconColor,
                  onLeadingTap: () => NavigatorHelper.pop(context),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 12),
                        child: Shimmer.fromColors(
                          baseColor: Colors.white.withOpacity(0.22),
                          highlightColor: Colors.white.withOpacity(0.48),
                          child: Container(
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.26)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          _bar(width: 120, height: 14),
                                          const SizedBox(height: 6),
                                          _bar(width: 80, height: 11),
                                        ],
                                      ),
                                      _bar(width: 60, height: 14),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Container(
                                      height: 1,
                                    color: Colors.white.withOpacity(0.26)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: List.generate(4, (_) {
                                      return Column(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.32),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          _bar(width: 40, height: 10),
                                          const SizedBox(height: 4),
                                          _bar(width: 30, height: 12),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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