// lib/presentation/pages/umrah/umrah_faq_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import '../../../configurations/frontend_config.dart';

import 'package:ziarat_app/presentation/elements/app_bar.dart';
import 'package:ziarat_app/presentation/elements/container.dart';
import '../../../infrastructure/models/masail.dart';
import '../../../infrastructure/services/masail.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';
import '../../elements/listTile.dart';
import '../../shimmers/faq_shimmer.dart';
import 'faq bottom sheet.dart';

// ─── In-memory cache ──────────────────────────────────────────────────────────
class _UmrahFaqCache {
  static final List<MasailModel> masail = [];
  static final List<CommonMistakeModel> mistakes = [];
  static final List<MasailModel> womens = [];

  static bool _masailPopulated = false;
  static bool _mistakesPopulated = false;
  static bool _womensPopulated = false;

  static bool get masailLoaded => _masailPopulated;
  static bool get mistakesLoaded => _mistakesPopulated;
  static bool get womensLoaded => _womensPopulated;

  static void markMasailPopulated() => _masailPopulated = true;
  static void markMistakesPopulated() => _mistakesPopulated = true;
  static void markWomensPopulated() => _womensPopulated = true;

  static void clearMasail() {
    masail.clear();
    _masailPopulated = false;
  }

  static void clearMistakes() {
    mistakes.clear();
    _mistakesPopulated = false;
  }

  static void clearWomens() {
    womens.clear();
    _womensPopulated = false;
  }
}

class UmrahFaqScreen extends StatefulWidget {
  const UmrahFaqScreen({super.key});

  @override
  State<UmrahFaqScreen> createState() => _UmrahFaqScreenState();
}

class _UmrahFaqScreenState extends State<UmrahFaqScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _pageSize = 10;

  // Tab 0 — Masail Q&A
  late PagingController<int, MasailModel> _masailPaging;
  // Tab 1 — Common Mistakes
  late PagingController<int, CommonMistakeModel> _mistakesPaging;
  // Tab 2 — Women's Guide
  late PagingController<int, MasailModel> _womensPaging;

  // ── Search ────────────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchBarVisible = false;
  bool _isSearchLoading = false;
  Timer? _debounceTimer;

  // Per-tab search results
  List<MasailModel> _masailSearchResults = [];
  List<CommonMistakeModel> _mistakesSearchResults = [];
  List<MasailModel> _womensSearchResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        // Clear search results when switching tabs so stale results don't show
        setState(() {
          _searchController.clear();
          _masailSearchResults = [];
          _mistakesSearchResults = [];
          _womensSearchResults = [];
          _isSearchLoading = false;
        });
      });

    _masailPaging = PagingController<int, MasailModel>(firstPageKey: 1)
      ..addPageRequestListener(_fetchMasailPage);

    _mistakesPaging =
    PagingController<int, CommonMistakeModel>(firstPageKey: 1)
      ..addPageRequestListener(_fetchMistakesPage);

    _womensPaging = PagingController<int, MasailModel>(firstPageKey: 1)
      ..addPageRequestListener(_fetchWomensPage);

    if (_UmrahFaqCache.masailLoaded) {
      _masailPaging.appendLastPage(List.of(_UmrahFaqCache.masail));
    }
    if (_UmrahFaqCache.mistakesLoaded) {
      _mistakesPaging.appendLastPage(List.of(_UmrahFaqCache.mistakes));
    }
    if (_UmrahFaqCache.womensLoaded) {
      _womensPaging.appendLastPage(List.of(_UmrahFaqCache.womens));
    }

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    _masailPaging.dispose();
    _mistakesPaging.dispose();
    _womensPaging.dispose();
    super.dispose();
  }

  // ── Fetchers ──────────────────────────────────────────────────────────────

  Future<void> _fetchMasailPage(int pageKey) async {
    if (_UmrahFaqCache.masailLoaded) return;
    try {
      final response = await MasailService.fetchUmrahMasail(
        page: pageKey,
        limit: _pageSize,
        category: 'Masail (Q/A)',
      );
      final isLastPage = response.data.length < _pageSize;
      _UmrahFaqCache.masail.addAll(response.data);
      _UmrahFaqCache.markMasailPopulated();
      if (isLastPage) {
        _masailPaging.appendLastPage(response.data);
      } else {
        _masailPaging.appendPage(response.data, pageKey + 1);
      }
    } catch (error) {
      _masailPaging.error = error;
      if (mounted) _showErrorSnackbar(error.toString());
    }
  }

  Future<void> _fetchMistakesPage(int pageKey) async {
    if (_UmrahFaqCache.mistakesLoaded) return;
    try {
      final response = await MasailService.fetchUmrahCommonMistakes(
        page: pageKey,
        limit: _pageSize,
      );
      final isLastPage = response.data.length < _pageSize;
      _UmrahFaqCache.mistakes.addAll(response.data);
      _UmrahFaqCache.markMistakesPopulated();
      if (isLastPage) {
        _mistakesPaging.appendLastPage(response.data);
      } else {
        _mistakesPaging.appendPage(response.data, pageKey + 1);
      }
    } catch (error) {
      _mistakesPaging.error = error;
      if (mounted) _showErrorSnackbar(error.toString());
    }
  }

  Future<void> _fetchWomensPage(int pageKey) async {
    if (_UmrahFaqCache.womensLoaded) return;
    try {
      final response = await MasailService.fetchUmrahWomensGuide(
        page: pageKey,
        limit: _pageSize,
        category: 'Women Guide',
      );
      final isLastPage = response.data.length < _pageSize;
      _UmrahFaqCache.womens.addAll(response.data);
      _UmrahFaqCache.markWomensPopulated();
      if (isLastPage) {
        _womensPaging.appendLastPage(response.data);
      } else {
        _womensPaging.appendPage(response.data, pageKey + 1);
      }
    } catch (error) {
      _womensPaging.error = error;
      if (mounted) _showErrorSnackbar(error.toString());
    }
  }

  // ── Search ────────────────────────────────────────────────────────────────

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final query = _searchController.text.trim();
      final lang = Get.locale?.languageCode ?? 'en';

      // ── Tab 1: Common Mistakes — filter from local cache ──────────────────
      if (_tabController.index == 1) {
        if (query.isEmpty) {
          setState(() => _mistakesSearchResults = []);
          return;
        }
        setState(() {
          _mistakesSearchResults = _UmrahFaqCache.mistakes.where((m) {
            return m
                .getLocalizedQuestion(lang)
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
        });
        return;
      }

      // ── Tab 2: Women's Guide — filter from local cache ────────────────────
      if (_tabController.index == 2) {
        if (query.isEmpty) {
          setState(() => _womensSearchResults = []);
          return;
        }
        setState(() {
          _womensSearchResults = _UmrahFaqCache.womens.where((m) {
            return m
                .getLocalizedQuestion(lang)
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
        });
        return;
      }

      // ── Tab 0: Masail Q&A — API search ────────────────────────────────────
      if (query.isEmpty) {
        setState(() {
          _isSearchLoading = false;
          _masailSearchResults = [];
        });
        return;
      }
      setState(() => _isSearchLoading = true);
      try {
        final response = await MasailService.searchMasail(
          query: query,
          masailType: 'Umrah Masail',
        );
        setState(() {
          _masailSearchResults = response.data;
          _isSearchLoading = false;
        });
      } catch (_) {
        setState(() {
          _masailSearchResults = [];
          _isSearchLoading = false;
        });
        if (mounted) _showErrorSnackbar('Search failed');
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchBarVisible = !_isSearchBarVisible;
      if (!_isSearchBarVisible) {
        _searchController.clear();
        _masailSearchResults = [];
        _mistakesSearchResults = [];
        _womensSearchResults = [];
        _isSearchLoading = false;
        _debounceTimer?.cancel();
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    ));
  }

  String _getFontFamily() {
    final locale = Get.locale?.languageCode;
    if (locale == 'ar') return 'noto-sans';
    if (locale == 'ur') return 'jameel-noori';
    return 'Raleway';
  }

  String _label(int i) {
    final lang = Get.locale?.languageCode ?? 'en';
    const en = ['Masail (Q&A)', 'Common Mistakes', "Women's Guide"];
    const ar = ['المسائل', 'الأخطاء الشائعة', 'دليل المرأة'];
    const ur = ['مسائل', 'عام غلط فہمیاں', 'خواتین مسائل'];
    if (lang == 'ar') return ar[i];
    if (lang == 'ur') return ur[i];
    return en[i];
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.faqAppBarTitleTxt.tr,
                        style: FrontEndConfig.headingTextStyle.copyWith(
                          fontSize: FrontEndConfig.fontSize(20),
                          fontFamily: _getFontFamily(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleSearch,
                        child: Image.asset(
                          AssetConstant.searchIcon,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (_isSearchBarVisible)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: TextField(
                      controller: _searchController,
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: _getFontFamily(),
                      ),
                      decoration: InputDecoration(
                        hintText: AppStrings.searchHintTxt.tr,
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontFamily: _getFontFamily(),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8),
                          child: Image.asset(
                            AssetConstant.searchIcon,
                            width: 20,
                            height: 20,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _masailSearchResults = [];
                              _mistakesSearchResults = [];
                              _womensSearchResults = [];
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppStrings.faqIntroTxt.tr,
                    style: FrontEndConfig.bodyTextStyle,
                  ),
                ),

                // TabBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 17.0, vertical: 10),
                  child: MyContainer(
                    height: 36,
                    gradient: FrontEndConfig.btnBorderColor,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: MyContainer(
                        decoration: BoxDecoration(
                          color:
                          FrontEndConfig.backgroundColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          unselectedLabelColor:
                          FrontEndConfig.textColor.withOpacity(0.6),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            gradient: FrontEndConfig.btnBorderColor,
                          ),
                          labelColor: FrontEndConfig.textColor,
                          labelPadding: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          tabs: List.generate(3, (i) {
                            final lang = Get.locale?.languageCode ?? 'en';
                            final tabFontSize = lang == 'ur'
                                ? FrontEndConfig.fontSize(14.5)
                                : FrontEndConfig.fontSize(10.5);
                            return Tab(
                              height: 34,
                              child: Text(
                                _label(i),
                                style: TextStyle(
                                  fontSize: tabFontSize,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                  fontFamily: _getFontFamily(),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMasailTab(),
                      _buildMistakesTab(),
                      _buildWomensTab(),
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

  // ── Tab 0: Masail Q&A (API search) ───────────────────────────────────────

  Widget _buildMasailTab() {
    if (_isSearchBarVisible && _isSearchLoading) return const FaqShimmer();
    if (_isSearchBarVisible && _searchController.text.isNotEmpty) {
      if (_masailSearchResults.isNotEmpty) {
        return _buildStaticMasailList(_masailSearchResults);
      }
      return Center(
        child: Text(AppStrings.noResultsFoundTxt.tr,
            style: FrontEndConfig.bodyTextStyle),
      );
    }
    return _buildMasailPagedTab(_masailPaging);
  }

  // ── Tab 1: Common Mistakes (local cache search) ───────────────────────────

  Widget _buildMistakesTab() {
    if (_isSearchBarVisible && _searchController.text.isNotEmpty) {
      if (_mistakesSearchResults.isNotEmpty) {
        return _buildStaticMistakesList(_mistakesSearchResults);
      }
      return Center(
        child: Text(AppStrings.noResultsFoundTxt.tr,
            style: FrontEndConfig.bodyTextStyle),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => _mistakesPaging.refresh(),
      child: PagedListView<int, CommonMistakeModel>(
        pagingController: _mistakesPaging,
        builderDelegate: PagedChildBuilderDelegate<CommonMistakeModel>(
          itemBuilder: (context, mistake, index) {
            final lang = Get.locale?.languageCode ?? 'en';
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 17.0, vertical: 6),
              child: CommonListTile(
                tileColor: FrontEndConfig.listTileColor,
                borderGradient: FrontEndConfig.listTileBorder,
                leading: CircleAvatar(
                  backgroundColor: const Color(0xffC89C18).withOpacity(0.3),
                  radius: 13,
                  child: Text(
                    "${index + 1}",
                    style: FrontEndConfig.headingTextStyle.copyWith(
                      fontSize: FrontEndConfig.fontSize(14),
                    ),
                  ),
                ),
                title: "${mistake.getLocalizedQuestion(lang)}\n${AppStrings.commonMistakesSeeMorTxt.tr}",
                trailing: Image.asset(AssetConstant.arrowDownIcon,
                    width: 10, height: 10),
                onTap: () =>
                    FaqBottomSheet.showMistake(context, index + 1, mistake),
              ),
            );
          },
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.errorLoadingDataTxt.tr,
                    style: FrontEndConfig.bodyTextStyle),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _mistakesPaging.refresh,
                  child: Text(AppStrings.retryBtnTxt.tr),
                ),
              ],
            ),
          ),
          newPageErrorIndicatorBuilder: (context) => Center(
            child: ElevatedButton(
              onPressed: _mistakesPaging.retryLastFailedRequest,
              child: Text(AppStrings.retryBtnTxt.tr),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(AppStrings.noItemsFoundTxt.tr,
                style: FrontEndConfig.bodyTextStyle),
          ),
          firstPageProgressIndicatorBuilder: (context) => const FaqShimmer(),
          newPageProgressIndicatorBuilder: (context) => _shimmerTile(),
        ),
      ),
    );
  }

  // ── Tab 2: Women's Guide (local cache search) ─────────────────────────────

  Widget _buildWomensTab() {
    if (_isSearchBarVisible && _searchController.text.isNotEmpty) {
      if (_womensSearchResults.isNotEmpty) {
        return _buildStaticMasailList(_womensSearchResults);
      }
      return Center(
        child: Text(AppStrings.noResultsFoundTxt.tr,
            style: FrontEndConfig.bodyTextStyle),
      );
    }
    return _buildMasailPagedTab(_womensPaging);
  }

  // ── Generic paged tab (MasailModel) ──────────────────────────────────────

  Widget _buildMasailPagedTab(PagingController<int, MasailModel> controller) {
    return RefreshIndicator(
      onRefresh: () async => controller.refresh(),
      child: PagedListView<int, MasailModel>(
        pagingController: controller,
        builderDelegate: PagedChildBuilderDelegate<MasailModel>(
          itemBuilder: (context, faq, index) {
            final lang = Get.locale?.languageCode ?? 'en';
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 17.0, vertical: 6),
              child: CommonListTile(
                tileColor: FrontEndConfig.listTileColor,
                borderGradient: FrontEndConfig.listTileBorder,
                leading: CircleAvatar(
                  backgroundColor: const Color(0xffC89C18).withOpacity(0.3),
                  radius: 13,
                  child: Text(
                    "${index + 1}",
                    style: FrontEndConfig.headingTextStyle.copyWith(
                      fontSize: FrontEndConfig.fontSize(14),
                    ),
                  ),
                ),
                title: faq.getLocalizedQuestion(lang),
                trailing: Image.asset(AssetConstant.arrowDownIcon,
                    width: 10, height: 10),
                onTap: () => FaqBottomSheet.show(context, index + 1, faq),
              ),
            );
          },
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStrings.errorLoadingDataTxt.tr,
                    style: FrontEndConfig.bodyTextStyle),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: Text(AppStrings.retryBtnTxt.tr),
                ),
              ],
            ),
          ),
          newPageErrorIndicatorBuilder: (context) => Center(
            child: ElevatedButton(
              onPressed: controller.retryLastFailedRequest,
              child: Text(AppStrings.retryBtnTxt.tr),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(AppStrings.noItemsFoundTxt.tr,
                style: FrontEndConfig.bodyTextStyle),
          ),
          firstPageProgressIndicatorBuilder: (context) => const FaqShimmer(),
          newPageProgressIndicatorBuilder: (context) => _shimmerTile(),
        ),
      ),
    );
  }

  // ── Static list renderers ─────────────────────────────────────────────────

  Widget _buildStaticMasailList(List<MasailModel> faqs) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10),
      itemCount: faqs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final faq = faqs[index];
        final lang = Get.locale?.languageCode ?? 'en';
        return CommonListTile(
          tileColor: FrontEndConfig.listTileColor,
          borderGradient: FrontEndConfig.listTileBorder,
          leading: CircleAvatar(
            backgroundColor: const Color(0xffC89C18).withOpacity(0.3),
            radius: 13,
            child: Text(
              "${index + 1}",
              style: FrontEndConfig.headingTextStyle.copyWith(
                fontSize: FrontEndConfig.fontSize(14),
              ),
            ),
          ),
          title: faq.getLocalizedQuestion(lang),
          trailing:
          Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
          onTap: () => FaqBottomSheet.show(context, index + 1, faq),
        );
      },
    );
  }

  Widget _buildStaticMistakesList(List<CommonMistakeModel> mistakes) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10),
      itemCount: mistakes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final mistake = mistakes[index];
        final lang = Get.locale?.languageCode ?? 'en';
        return CommonListTile(
          tileColor: FrontEndConfig.listTileColor,
          borderGradient: FrontEndConfig.listTileBorder,
          leading: CircleAvatar(
            backgroundColor: const Color(0xffC89C18).withOpacity(0.3),
            radius: 13,
            child: Text(
              "${index + 1}",
              style: FrontEndConfig.headingTextStyle.copyWith(
                fontSize: FrontEndConfig.fontSize(14),
              ),
            ),
          ),
          title: "${mistake.getLocalizedQuestion(lang)}\n${AppStrings.commonMistakesSeeMorTxt.tr}",
          trailing:
          Image.asset(AssetConstant.arrowDownIcon, width: 10, height: 10),
          onTap: () => FaqBottomSheet.showMistake(context, index + 1, mistake),
        );
      },
    );
  }

  Widget _shimmerTile() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 6),
    child: Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.22),
      highlightColor: Colors.white.withOpacity(0.48),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.26)),
        ),
      ),
    ),
  );
}