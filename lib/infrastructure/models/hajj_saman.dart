// To parse this JSON data, do
//
//     final hajjSamanModel = HajjSamanModel.fromJson(json);

import 'dart:convert';
import 'package:get/get.dart';

HajjSamanModel hajjSamanModelFromJson(String str) =>
    HajjSamanModel.fromJson(json.decode(str));

String hajjSamanModelToJson(HajjSamanModel data) => json.encode(data.toJson());

class HajjSamanModel {
  final bool? success;
  final int? count;
  final List<HajjSamanData>? data;

  HajjSamanModel({
    this.success,
    this.count,
    this.data,
  });

  factory HajjSamanModel.fromJson(Map<String, dynamic> json) => HajjSamanModel(
    success: json["success"],
    count: json["count"],
    data: json["data"] == null
        ? []
        : List<HajjSamanData>.from(
        json["data"]!.map((x) => HajjSamanData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HajjSamanData {
  final String? id;
  final String? contentEn;
  final String? contentUr;
  final String? contentAr;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  HajjSamanData({
    this.id,
    this.contentEn,
    this.contentUr,
    this.contentAr,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// Returns localised HTML content based on current app locale.
  String get localizedContent {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ur' && (contentUr?.isNotEmpty ?? false)) return contentUr!;
    if (lang == 'ar' && (contentAr?.isNotEmpty ?? false)) return contentAr!;
    return contentEn ?? '';
  }

  factory HajjSamanData.fromJson(Map<String, dynamic> json) => HajjSamanData(
    id: json["_id"],
    contentEn: json["content_en"],
    contentUr: json["content_ur"],
    contentAr: json["content_ar"],
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "content_en": contentEn,
    "content_ur": contentUr,
    "content_ar": contentAr,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}