import 'dart:convert';

PackageListingModel packageListingModelFromJson(String str) => PackageListingModel.fromJson(json.decode(str));

String packageListingModelToJson(PackageListingModel data) => json.encode(data.toJson());

class PackageListingModel {
  final bool? success;
  final int? count;
  final List<PackageModel>? data;

  PackageListingModel({
    this.success,
    this.count,
    this.data,
  });

  factory PackageListingModel.fromJson(Map<String, dynamic> json) => PackageListingModel(
    success: json["success"],
    count: json["count"],
    data: json["data"] == null ? [] : List<PackageModel>.from(json["data"]!.map((x) => PackageModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PackageModel {
  final String? id;
  final ProviderId? providerId;
  final String? packageTitle;
  final int? amount;
  final String? duration;
  final int? gbs;
  final int? onNetMinutes;
  final int? interMinutes;
  final int? sms;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PackageModel({
    this.id,
    this.providerId,
    this.packageTitle,
    this.amount,
    this.duration,
    this.gbs,
    this.onNetMinutes,
    this.interMinutes,
    this.sms,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    id: json["_id"],
    providerId: json["providerId"] == null
        ? null
        : json["providerId"] is String          // ✅ handle string
        ? ProviderId(id: json["providerId"])
        : ProviderId.fromJson(json["providerId"]),
    packageTitle: json["packageTitle"],
    amount: json["amount"],
    duration: json["duration"],
    gbs: json["gbs"],
    onNetMinutes: json["onNetMinutes"],
    interMinutes: json["interMinutes"],
    sms: json["sms"],
    isActive: json["isActive"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "providerId": providerId?.toJson(),
    "packageTitle": packageTitle,
    "amount": amount,
    "duration": duration,
    "gbs": gbs,
    "onNetMinutes": onNetMinutes,
    "interMinutes": interMinutes,
    "sms": sms,
    "isActive": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class ProviderId {
  final String? id;
  final String? image;
  final String? title;
  final String? helplineNumber;

  ProviderId({
    this.id,
    this.image,
    this.title,
    this.helplineNumber,
  });

  factory ProviderId.fromJson(Map<String, dynamic> json) => ProviderId(
    id: json["_id"],
    image: json["Image"],
    title: json["Title"],
    helplineNumber: json["HelplineNumber"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "Image": image,
    "Title": title,
    "HelplineNumber": helplineNumber,
  };
}