import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ziarat_app/application/ziarat_bloc/ziarat_bloc.dart';
import 'package:ziarat_app/infrastructure/models/ziarat.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import '../../../application/navigation_helper.dart';
import '../../../configurations/frontend_config.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';
import '../ziarat_details/layout/body.dart';

class Ziarat extends StatefulWidget {
  final ZiaratBloc ziaratBloc;

  const Ziarat({super.key, required this.ziaratBloc});

  @override
  State<Ziarat> createState() => _ZiaratState();
}

class _ZiaratState extends State<Ziarat> with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  bool isSearching = false;
  Timer? _debounce;
  List<ZiaratModel> _currentList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (isSearching) return;
      if (_tabController.index == 0) {
        widget.ziaratBloc.add(const GetMakkahZiaratEvent());
      } else {
        widget.ziaratBloc.add(const GetMadinaZiaratEvent());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      if (_tabController.index == 0) {
        widget.ziaratBloc.add(const GetMakkahZiaratEvent());
      } else {
        widget.ziaratBloc.add(const GetMadinaZiaratEvent());
      }
      return;
    }

    if (query.trim().length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 600), () {
      widget.ziaratBloc.add(SearchZiaratEvent(keyword: query));
    });
  }

  void _onSearchToggle() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        _debounce?.cancel();
        searchController.clear();
        if (_tabController.index == 0) {
          widget.ziaratBloc.add(const GetMakkahZiaratEvent());
        } else {
          widget.ziaratBloc.add(const GetMadinaZiaratEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),
          Positioned.fill(
            child:
            Image.asset(AssetConstant.backgroundimage, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                /// AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CommonAppBar(
                    title: AppStrings.ziyaratAppBarTitleTxt.tr,
                    color: FrontEndConfig.iconColor,
                    actionIcon: AssetConstant.searchIcon,
                    onActionTap: _onSearchToggle,
                  ),
                ),

                /// Search Field
                if (isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: MyContainer(
                      decoration: BoxDecoration(
                        gradient: FrontEndConfig.btnBorderColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: TextField(
                          controller: searchController,
                          onChanged: _onSearch,
                          style: FrontEndConfig.bodyTextStyle,
                          decoration: InputDecoration(
                            hintText: AppStrings.searchZiyaratHintTxt.tr,
                            hintStyle: FrontEndConfig.subHeadingTextStyle,
                            filled: true,
                            fillColor:
                            FrontEndConfig.backgroundColor.withOpacity(0.8),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.asset(
                                AssetConstant.searchIcon,
                                width: 2,
                                height: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                /// TabBar — hide when searching
                if (!isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: MyContainer(
                      height: 50,
                      gradient: FrontEndConfig.btnBorderColor,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: MyContainer(
                          decoration: BoxDecoration(
                            color: FrontEndConfig.backgroundColor
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            unselectedLabelColor: FrontEndConfig.textColor,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: FrontEndConfig.btnBorderColor,
                            ),
                            labelColor: FrontEndConfig.textColor,
                            tabs: [
                              Text(AppStrings.makkahTabTxt.tr,
                                  style: FrontEndConfig.tabBarTextStyle),
                              Text(AppStrings.madinaTabTxt.tr,
                                  style: FrontEndConfig.tabBarTextStyle),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                /// Content
                Expanded(
                  child: BlocBuilder<ZiaratBloc, ZiaratState>(
                    bloc: widget.ziaratBloc,
                    builder: (context, state) {
                      if (state is ZiaratInitial || state is ZiaratLoading) {
                        return _ZiaratShimmer();
                      }

                      if (state is ZiaratFailed) {
                        return Center(
                          child: Text(
                            state.message,
                            style: FrontEndConfig.headingTextStyle,
                          ),
                        );
                      }

                      if (state is ZiaratLoaded) {
                        _currentList = state.model.data ?? [];
                        if (_currentList.isEmpty) {
                          return Center(
                            child: Text(AppStrings.noResultsFoundTxt.tr,
                                style: FrontEndConfig.headingTextStyle),
                          );
                        }
                        return _buildZiaratList(_currentList);
                      }

                      if (state is ZiaratSearchLoaded) {
                        final searchList = state.model.data ?? [];
                        if (searchList.isEmpty) {
                          return Center(
                            child: Text(AppStrings.noResultsFoundTxt.tr,
                                style: FrontEndConfig.headingTextStyle),
                          );
                        }
                        return _buildZiaratList(searchList);
                      }

                      if (_currentList.isNotEmpty) {
                        return _buildZiaratList(_currentList);
                      }

                      return const SizedBox();
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

  Widget _buildZiaratList(List<ZiaratModel> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final ZiaratModel item = list[index];
        final String imageUrl =
        (item.images != null && item.images!.isNotEmpty)
            ? item.images!.first
            : "";

        return GestureDetector(
          onTap: () {
            NavigatorHelper.push(
              context,
              ZiaratDetailsViewBody(item: item),
              animation: NavigationAnimation.slide,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: MyContainer(
              height: 296,
              decoration: BoxDecoration(
                gradient: FrontEndConfig.btnBorderColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: MyContainer(
                  decoration: BoxDecoration(
                    color: FrontEndConfig.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 163,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          imageBuilder: (context, imageProvider) {
                            debugPrint('✅ IMAGE LOADED: $imageUrl');
                            return Container(
                              height: 163,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                          placeholder: (context, url) {
                            return Image.asset(
                              'assets/images/logo2.png',
                              height: 163,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            );
                          },
                          errorWidget: (context, url, error) {
                            debugPrint('❌ IMAGE ERROR: $error for $url');
                            return Image.asset(
                              AssetConstant.masjid,
                              height: 163,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            );
                          },
                        )
                            : Image.asset(
                          AssetConstant.masjid,
                          height: 163,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      0.01.height(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11.0),
                        child: Text(
                          item.title ?? "",
                          style: FrontEndConfig.headingTextStyle,
                        ),
                      ),
                      0.01.height(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11.0),
                        child: Row(
                          children: [
                            Image.asset(AssetConstant.location,
                                width: 18, height: 18),
                            0.01.width(context),
                            Text(
                              item.type ?? "",
                              style: FrontEndConfig.subHeadingTextStyle,
                            ),
                          ],
                        ),
                      ),
                      0.01.height(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11.0),
                        child: Text(
                          "${item.description ?? ""}${AppStrings.seeMoreSuffixTxt.tr}",
                          style: FrontEndConfig.bodyTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
}

// ─── Ziarat Shimmer ───────────────────────────────────────────────────────────

class _ZiaratShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.22),
            highlightColor: Colors.white.withOpacity(0.48),
            child: Container(
              height: 296,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.26)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    height: 163,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.26),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: _bar(
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: 15),
                  ),

                  const SizedBox(height: 10),

                  // Location row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.32),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _bar(width: 80, height: 12),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Description line 1
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: _bar(width: double.infinity, height: 12),
                  ),

                  const SizedBox(height: 6),

                  // Description line 2
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: _bar(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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