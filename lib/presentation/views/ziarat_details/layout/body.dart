import 'package:flutter/material.dart';
import 'package:ziarat_app/infrastructure/models/ziarat.dart';
import 'package:ziarat_app/infrastructure/models/ziarat_details.dart';

import '../ziarat_details.dart';

class ZiaratDetailsViewBody extends StatelessWidget {
  final ZiaratModel item;

  const ZiaratDetailsViewBody({super.key, required this.item});

  /// Convert ZiaratModel → Data (ZiaratDetailModel's Data class)
  Data _toDetailData() {
    return Data(
      id: item.id,
      type: item.type,
      title: item.title,
      description: item.description,
      dua: item.dua,
      lat: item.lat,
      lng: item.lng,
      images: item.images,
      audioGuide: item.audioGuide,
      isActive: item.isActive,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      v: item.v,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZiaratDetails(data: _toDetailData());
  }
}