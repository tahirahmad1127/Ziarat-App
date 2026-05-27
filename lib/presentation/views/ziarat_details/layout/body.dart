import 'package:flutter/material.dart';
import 'package:ziarat_app/infrastructure/models/ziarat.dart';
import 'package:ziarat_app/infrastructure/models/ziarat_details.dart';

import '../../../../infrastructure/services/ziarat.dart';
import '../../../../injection_container.dart';
import '../ziarat_details.dart';

class ZiaratDetailsViewBody extends StatefulWidget {
  final ZiaratModel item;

  const ZiaratDetailsViewBody({super.key, required this.item});

  @override
  State<ZiaratDetailsViewBody> createState() => _ZiaratDetailsViewBodyState();
}

class _ZiaratDetailsViewBodyState extends State<ZiaratDetailsViewBody> {
  /// Start with data built from the listing model so the screen
  /// renders immediately with no black screen or spinner.
  late Data _data;

  @override
  void initState() {
    super.initState();
    // Build initial Data from the listing item — screen shows instantly.
    _data = _fromListingItem(widget.item);
    // Then silently fetch the full detail (importantPoints etc.) in background.
    _fetchDetail();
  }

  /// Converts a ZiaratModel (listing) → Data so the screen renders immediately.
  Data _fromListingItem(ZiaratModel item) {
    return Data(
      id: item.id,
      type: item.type,
      duaRaw: item.dua,
      lat: item.lat,
      lng: item.lng,
      images: item.images?.map((e) => e.imageUrl ?? '').toList(),
      titleMap: item.titleMap,
      descriptionMap: item.descriptionMap,
      audioGuideMap: item.audioGuideMap,
      importantPointsMap: item.importantPointsMap,
      zikarMap: item.zikarMap,
      nafalPrayerMap: item.nafalPrayerMap,
      isActive: item.isActive,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      v: item.v,
    );
  }

  /// Fetches full detail from the API silently in the background.
  /// Updates state only when the richer data (importantPoints etc.) arrives.
  Future<void> _fetchDetail() async {
    if (widget.item.id == null) {
      debugPrint('❌ id is null');
      return;
    }
    debugPrint('🔍 fetching detail for id: ${widget.item.id}');

    final repo = sl<ZiaratRepository>();
    final result = await repo.getZiaratDetail(widget.item.id!);

    result.fold(
          (error) => debugPrint('❌ Detail fetch error: ${error.error}'),
          (detail) => debugPrint('✅ importantPoints: ${detail.data?.importantPoints}'),
    );
  }
  @override
  Widget build(BuildContext context) {
    // Always renders ZiaratDetails — first with listing data, then
    // silently upgrades to full detail data once the API responds.
    return ZiaratDetails(data: _data);
  }
}