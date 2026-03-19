// packages.dart - CORRECTED MODEL

import 'dart:convert';

PackageListingModel packageListingModelFromJson(String str) => PackageListingModel.fromJson(json.decode(str));

String packageListingModelToJson(PackageListingModel data) => json.encode(data.toJson());

class PackageListingModel {
  final bool? success;
  final int? count;
  final List<PackageModel>? data;
  final String? message;

  PackageListingModel({
    this.success,
    this.count,
    this.data,
    this.message,
  });

  factory PackageListingModel.fromJson(Map<String, dynamic> json) => PackageListingModel(
    success: json["success"],
    count: json["count"],
    data: json["data"] == null ? [] : List<PackageModel>.from(json["data"]!.map((x) => PackageModel.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class PackageModel {
  final String? id;
  /// Backend may return providerId as String or as populated object.
  final String? providerId;
  final ProviderInfo? providerInfo;
  final String? providerName;
  final String? packageName;
  final String? duration;
  final int? price;
  final String? currency;
  final int? dataGB;
  final int? onNetMinutes;
  final int? internationalMinutes;
  final int? sms;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PackageModel({
    this.id,
    this.providerId,
    this.providerInfo,
    this.providerName,
    this.packageName,
    this.duration,
    this.price,
    this.currency,
    this.dataGB,
    this.onNetMinutes,
    this.internationalMinutes,
    this.sms,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    id: json["_id"],
    providerId: json["providerId"] is String
        ? json["providerId"] as String
        : (json["providerId"] is Map<String, dynamic>
            ? (json["providerId"]["_id"] as String?)
            : null),
    providerInfo: json["providerId"] is Map<String, dynamic>
        ? ProviderInfo.fromJson(json["providerId"] as Map<String, dynamic>)
        : null,
    providerName: json["providerName"],
    packageName: json["packageName"],
    duration: json["duration"],
    price: json["price"],
    currency: json["currency"],
    dataGB: json["dataGB"],
    onNetMinutes: json["onNetMinutes"],
    internationalMinutes: json["internationalMinutes"],
    sms: json["sms"],
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "providerId": providerInfo?.toJson() ?? providerId,
    "providerName": providerName,
    "packageName": packageName,
    "duration": duration,
    "price": price,
    "currency": currency,
    "dataGB": dataGB,
    "onNetMinutes": onNetMinutes,
    "internationalMinutes": internationalMinutes,
    "sms": sms,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class ProviderInfo {
  final String? id;
  final String? providerImage;
  final String? providerName;
  final String? helplineNumber;

  ProviderInfo({
    this.id,
    this.providerImage,
    this.providerName,
    this.helplineNumber,
  });

  factory ProviderInfo.fromJson(Map<String, dynamic> json) => ProviderInfo(
    id: json["_id"],
    providerImage: json["ProviderImage"],
    providerName: json["ProviderName"],
    helplineNumber: json["HelplineNumber"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ProviderImage": providerImage,
    "ProviderName": providerName,
    "HelplineNumber": helplineNumber,
  };
}