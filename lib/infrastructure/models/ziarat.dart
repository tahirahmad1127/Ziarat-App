// To parse this JSON data, do
//
//     final ziaratListingModel = ziaratListingModelFromJson(jsonString);

import 'dart:convert';

ZiaratListingModel ziaratListingModelFromJson(String str) => ZiaratListingModel.fromJson(json.decode(str));

String ziaratListingModelToJson(ZiaratListingModel data) => json.encode(data.toJson());

class ZiaratListingModel {
  final bool? success;
  final int? count;
  final List<ZiaratModel>? data;

  ZiaratListingModel({
    this.success,
    this.count,
    this.data,
  });

  factory ZiaratListingModel.fromJson(Map<String, dynamic> json) => ZiaratListingModel(
    success: json["success"],
    count: json["count"],
    data: json["data"] == null
        ? []
        : List<ZiaratModel>.from(json["data"]!.map((x) => ZiaratModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
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
  final String? title;
  final String? description;
  final String? dua;
  final double? lat;
  final double? lng;
  final List<ImageModel>? images;
  final String? audioGuide;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ZiaratModel({
    this.id,
    this.type,
    this.title,
    this.description,
    this.dua,
    this.lat,
    this.lng,
    this.images,
    this.audioGuide,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Safely converts any field to String? — handles String, Map, List, num, bool
  static String? _safeString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) {
      // Try common keys first, then fall back to first non-null value
      for (final key in ['text', 'arabic', 'value', 'name', 'title', 'content']) {
        if (value[key] != null) return value[key].toString();
      }
      return value.values.firstWhere((v) => v != null, orElse: () => null)?.toString();
    }
    return value.toString();
  }

  factory ZiaratModel.fromJson(Map<String, dynamic> json) {


    return ZiaratModel(
      id: _safeString(json["_id"]),
      type: _safeString(json["type"]),
      title: _safeString(json["title"]),
      description: _safeString(json["description"]),
      dua: _safeString(json["dua"]),
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
      audioGuide: _safeString(json["audioGuide"]),
      isActive: json["isActive"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "title": title,
    "description": description,
    "dua": dua,
    "lat": lat,
    "lng": lng,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "audioGuide": audioGuide,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}