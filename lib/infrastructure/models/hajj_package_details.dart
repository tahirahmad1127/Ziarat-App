// To parse this JSON data, do
//
//     final hajjPackageDetailModel = HajjPackageDetailModel.fromJson(json);

import 'dart:convert';
import 'package:get/get.dart';

HajjPackageDetailModel hajjPackageDetailModelFromJson(String str) =>
    HajjPackageDetailModel.fromJson(json.decode(str));

String hajjPackageDetailModelToJson(HajjPackageDetailModel data) =>
    json.encode(data.toJson());

class HajjPackageDetailModel {
  final bool? success;
  final int? count;
  final List<HajjPackageDetailData>? data;

  HajjPackageDetailModel({
    this.success,
    this.count,
    this.data,
  });

  factory HajjPackageDetailModel.fromJson(Map<String, dynamic> json) =>
      HajjPackageDetailModel(
        success: json["success"],
        count: json["count"],
        data: json["data"] == null
            ? []
            : List<HajjPackageDetailData>.from(
            json["data"]!.map((x) => HajjPackageDetailData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HajjPackageDetailData {
  final String? id;
  final String? contentEn;
  final String? contentUr;
  final String? contentAr;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  HajjPackageDetailData({
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

  factory HajjPackageDetailData.fromJson(Map<String, dynamic> json) =>
      HajjPackageDetailData(
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