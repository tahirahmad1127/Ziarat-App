// To parse this JSON data, do
//
//     final ziaratDetailModel = ziaratDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

ZiaratDetailModel ziaratDetailModelFromJson(String str) =>
    ZiaratDetailModel.fromJson(json.decode(str));

String ziaratDetailModelToJson(ZiaratDetailModel data) =>
    json.encode(data.toJson());

class ZiaratDetailModel {
  final bool? success;
  final Data? data;

  ZiaratDetailModel({
    this.success,
    this.data,
  });

  factory ZiaratDetailModel.fromJson(Map<String, dynamic> json) =>
      ZiaratDetailModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  final String? id;
  final String? type;
  final double? lat;
  final double? lng;
  final List<String>? images;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  // All localised fields stored as maps
  final Map<String, String> _titleMap;
  final Map<String, String> _descriptionMap;
  final Map<String, String> _audioGuideMap;
  final Map<String, String> _importantPointsMap;
  final Map<String, String> _zikarMap;
  final Map<String, String> _nafalPrayerMap;
  final String? _duaRaw; // dua is a single string (not localised in the API)

  Data({
    this.id,
    this.type,
    this.lat,
    this.lng,
    this.images,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
    String? duaRaw,
    Map<String, String>? titleMap,
    Map<String, String>? descriptionMap,
    Map<String, String>? audioGuideMap,
    Map<String, String>? importantPointsMap,
    Map<String, String>? zikarMap,
    Map<String, String>? nafalPrayerMap,
  })  : _duaRaw = duaRaw,
        _titleMap = titleMap ?? {},
        _descriptionMap = descriptionMap ?? {},
        _audioGuideMap = audioGuideMap ?? {},
        _importantPointsMap = importantPointsMap ?? {},
        _zikarMap = zikarMap ?? {},
        _nafalPrayerMap = nafalPrayerMap ?? {};

  // ─── Locale helpers ──────────────────────────────────────────────────────────

  static String get _localeCode {
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'ur' || code == 'ar') return code;
    return 'en';
  }

  static String? _pickLocalized(Map<String, String> map) {
    if (map.isEmpty) return null;
    return map[_localeCode] ??
        map['en'] ??
        (map.values.isNotEmpty ? map.values.first : null);
  }

  /// Parses a value that may be either a localised map {"en":…,"ur":…,"ar":…}
  /// or a plain string (legacy / single-language response).
  static Map<String, String> _parseLocaleMap(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      final result = <String, String>{};
      for (final entry in value.entries) {
        if (entry.value != null && entry.value.toString().trim().isNotEmpty) {
          result[entry.key.toString()] = entry.value.toString();
        }
      }
      return result;
    }
    // Plain string — treat as English fallback
    return {'en': value.toString()};
  }

  // ─── Public localised getters ────────────────────────────────────────────────

  /// Localised title, e.g. "Jabal al-Noor" / "جبل النور" / "جَبَلُ ٱلنُّور"
  String? get title => _pickLocalized(_titleMap);

  /// Localised HTML description
  String? get description => _pickLocalized(_descriptionMap);

  /// Localised audio-guide URL
  String? get audioGuide => _pickLocalized(_audioGuideMap);

  /// Localised HTML important-points content
  String? get importantPoints => _pickLocalized(_importantPointsMap);

  /// Dua — returned as a single (Arabic) string from the API
  String? get dua => _duaRaw;

  /// Localised HTML zikar (remembrance) content
  String? get zikar => _pickLocalized(_zikarMap);

  /// Localised HTML nafalPrayer content
  String? get nafalPrayer => _pickLocalized(_nafalPrayerMap);

  // ─── Serialisation ───────────────────────────────────────────────────────────

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    type: json["type"],
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
    images: json["images"] == null
        ? []
        : List<String>.from(json["images"]!.map((x) => x)),
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    duaRaw: json["dua"],
    titleMap: _parseLocaleMap(json["title"]),
    descriptionMap: _parseLocaleMap(json["description"]),
    audioGuideMap: _parseLocaleMap(json["audioGuide"]),
    importantPointsMap: _parseLocaleMap(json["importantPoints"]),
    zikarMap: _parseLocaleMap(json["zikar"]),
    nafalPrayerMap: _parseLocaleMap(json["nafalPrayer"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "lat": lat,
    "lng": lng,
    "images":
    images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "dua": _duaRaw,
    "title": _titleMap,
    "description": _descriptionMap,
    "audioGuide": _audioGuideMap,
    "importantPoints": _importantPointsMap,
    "zikar": _zikarMap,
    "nafalPrayer": _nafalPrayerMap,
  };
}