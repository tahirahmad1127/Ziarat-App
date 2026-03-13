// To parse this JSON data, do
//
//     final ziaratDetailModel = ziaratDetailModelFromJson(jsonString);

import 'dart:convert';

ZiaratDetailModel ziaratDetailModelFromJson(String str) => ZiaratDetailModel.fromJson(json.decode(str));

String ziaratDetailModelToJson(ZiaratDetailModel data) => json.encode(data.toJson());

class ZiaratDetailModel {
  final bool? success;
  final Data? data;

  ZiaratDetailModel({
    this.success,
    this.data,
  });

  factory ZiaratDetailModel.fromJson(Map<String, dynamic> json) => ZiaratDetailModel(
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
