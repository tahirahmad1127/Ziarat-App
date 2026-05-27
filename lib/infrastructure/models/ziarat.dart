// To parse this JSON data, do
//
//     final ziaratListingModel = ziaratListingModelFromJson(jsonString);

import 'dart:convert';
import 'package:get/get.dart';

ZiaratListingModel ziaratListingModelFromJson(String str) =>
    ZiaratListingModel.fromJson(json.decode(str));

String ziaratListingModelToJson(ZiaratListingModel data) =>
    json.encode(data.toJson());

class ZiaratListingModel {
  final bool? success;
  final int? count;
  final List<ZiaratModel>? data;

  ZiaratListingModel({
    this.success,
    this.count,
    this.data,
  });

  factory ZiaratListingModel.fromJson(Map<String, dynamic> json) =>
      ZiaratListingModel(
        success: json["success"],
        count: json["count"],
        data: json["data"] == null
            ? []
            : List<ZiaratModel>.from(
            json["data"]!.map((x) => ZiaratModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ImageModel {
  final String? url;
  final String? key;

  ImageModel({this.url, this.key});

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    url: json["url"],
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "key": key,
  };

  /// Convenience getter — returns url, falling back to key if url is null
  String? get imageUrl => url ?? key;
}

class ZiaratModel {
  final String? id;
  final String? type;
  final double? lat;
  final double? lng;
  final List<ImageModel>? images;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  // ── Multilingual fields stored as raw maps ────────────────────────────────
  // If the API sends a plain String (legacy), it's stored under key 'en'.
  final Map<String, String> _titleMap;
  final Map<String, String> _descriptionMap;
  final Map<String, String> _importantPointsMap;
  final Map<String, String> _audioGuideMap;
  final Map<String, String> _zikarMap;
  final Map<String, String> _nafalPrayerMap;

  // Plain string field (not localised in the API)
  final String? dua;

  ZiaratModel({
    this.id,
    this.type,
    this.dua,
    this.lat,
    this.lng,
    this.images,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
    Map<String, String>? titleMap,
    Map<String, String>? descriptionMap,
    Map<String, String>? importantPointsMap,
    Map<String, String>? audioGuideMap,
    Map<String, String>? zikarMap,
    Map<String, String>? nafalPrayerMap,
  })  : _titleMap = titleMap ?? {},
        _descriptionMap = descriptionMap ?? {},
        _importantPointsMap = importantPointsMap ?? {},
        _audioGuideMap = audioGuideMap ?? {},
        _zikarMap = zikarMap ?? {},
        _nafalPrayerMap = nafalPrayerMap ?? {};

  // ── Locale-aware getters ──────────────────────────────────────────────────

  /// Returns the current app locale code as 'en', 'ur', or 'ar'.
  static String get _locale {
    final code = Get.locale?.languageCode ?? 'en';
    // Normalise: only accept codes we know the API uses
    if (code == 'ur' || code == 'ar') return code;
    return 'en';
  }

  /// Picks the value for the current locale, falling back to 'en'.
  static String? _pick(Map<String, String> map) {
    if (map.isEmpty) return null;
    return map[_locale] ?? map['en'] ?? map.values.firstOrNull;
  }

  String? get title => _pick(_titleMap);
  String? get description => _pick(_descriptionMap);
  String? get importantPoints => _pick(_importantPointsMap);
  String? get audioGuide => _pick(_audioGuideMap);

  String? get zikar => _pick(_zikarMap);
  String? get nafalPrayer => _pick(_nafalPrayerMap);

  // ── Raw map accessors (for detail screen if needed) ───────────────────────
  Map<String, String> get titleMap => _titleMap;
  Map<String, String> get descriptionMap => _descriptionMap;
  Map<String, String> get importantPointsMap => _importantPointsMap;
  Map<String, String> get audioGuideMap => _audioGuideMap;
  Map<String, String> get zikarMap => _zikarMap;
  Map<String, String> get nafalPrayerMap => _nafalPrayerMap;

  // ── Parsing helpers ───────────────────────────────────────────────────────

  /// Converts a JSON value into a {locale: value} map.
  /// Handles three cases:
  ///   1. Already a Map  → {"en": "...", "ur": "...", "ar": "..."}
  ///   2. Plain String   → {"en": "..."}  (legacy / simple fields)
  ///   3. null           → {}
  static Map<String, String> _parseLocaleMap(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      final result = <String, String>{};
      for (final entry in value.entries) {
        if (entry.value != null) {
          result[entry.key.toString()] = entry.value.toString();
        }
      }
      return result;
    }
    // Plain string — store as English fallback
    return {'en': value.toString()};
  }

  factory ZiaratModel.fromJson(Map<String, dynamic> json) {
    return ZiaratModel(
      id: json["_id"]?.toString(),
      type: json["type"]?.toString(),
      dua: json["dua"]?.toString(),
      lat: json["lat"]?.toDouble(),
      lng: json["lng"]?.toDouble(),
      images: json["images"] == null
          ? []
          : List<ImageModel>.from(
        json["images"]!.map((x) {
          if (x is Map<String, dynamic>) return ImageModel.fromJson(x);
          return ImageModel(url: x.toString());
        }),
      ),
      isActive: json["isActive"],
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
          ? null
          : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      // ── Parse multilingual maps ──────────────────────────────────────────
      titleMap: _parseLocaleMap(json["title"]),
      descriptionMap: _parseLocaleMap(json["description"]),
      importantPointsMap: _parseLocaleMap(json["importantPoints"]),
      audioGuideMap: _parseLocaleMap(json["audioGuide"]),
      zikarMap: _parseLocaleMap(json["zikar"]),
      nafalPrayerMap: _parseLocaleMap(json["nafalPrayer"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "title": _titleMap,
    "description": _descriptionMap,
    "importantPoints": _importantPointsMap,
    "audioGuide": _audioGuideMap,
    "zikar": _zikarMap,
    "nafalPrayer": _nafalPrayerMap,
    "dua": dua,
    "lat": lat,
    "lng": lng,
    "images": images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x.toJson())),
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}