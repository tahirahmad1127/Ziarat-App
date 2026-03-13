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
    data: json["data"] == null ? [] : List<ZiaratModel>.from(json["data"]!.map((x) => ZiaratModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ZiaratModel {
  final String? id;
  final String? type;
  final String? title;
  final String? description;
  final String? dua;
  final double? lat;
  final double? lng;
  final List<String>? images;
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

  factory ZiaratModel.fromJson(Map<String, dynamic> json) => ZiaratModel(
    id: json["_id"],
    type: json["type"],
    title: json["title"],
    description: json["description"],
    dua: json["dua"],
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    audioGuide: json["audioGuide"],
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "title": title,
    "description": description,
    "dua": dua,
    "lat": lat,
    "lng": lng,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "audioGuide": audioGuide,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
