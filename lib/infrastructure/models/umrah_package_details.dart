// To parse this JSON data, do
//
//     final umrahPackageDetailModel = UmrahPackageDetailModel.fromJson(json);

import 'dart:convert';
import 'package:get/get.dart';

UmrahPackageDetailModel umrahPackageDetailModelFromJson(String str) =>
    UmrahPackageDetailModel.fromJson(json.decode(str));

String umrahPackageDetailModelToJson(UmrahPackageDetailModel data) =>
    json.encode(data.toJson());

class UmrahPackageDetailModel {
  final bool? success;
  final int? count;
  final List<UmrahPackageDetailData>? data;

  UmrahPackageDetailModel({
    this.success,
    this.count,
    this.data,
  });

  factory UmrahPackageDetailModel.fromJson(Map<String, dynamic> json) =>
      UmrahPackageDetailModel(
        success: json["success"],
        count: json["count"],
        data: json["data"] == null
            ? []
            : List<UmrahPackageDetailData>.from(
            json["data"]!.map((x) => UmrahPackageDetailData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UmrahPackageDetailData {
  final String? id;
  final String? contentEn;
  final String? contentUr;
  final String? contentAr;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  UmrahPackageDetailData({
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

  factory UmrahPackageDetailData.fromJson(Map<String, dynamic> json) =>
      UmrahPackageDetailData(
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