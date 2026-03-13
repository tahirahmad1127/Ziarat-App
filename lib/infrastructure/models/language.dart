// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'dart:convert';

LanguageListingModel languageModelFromJson(String str) => LanguageListingModel.fromJson(json.decode(str));

String languageModelToJson(LanguageListingModel data) => json.encode(data.toJson());

class LanguageListingModel {
  final bool? success;
  final int? count;
  final List<LanguageModel>? data;

  LanguageListingModel({
    this.success,
    this.count,
    this.data,
  });

  factory LanguageListingModel.fromJson(Map<String, dynamic> json) => LanguageListingModel(
    success: json["success"],
    count: json["count"],
    data: json["data"] == null ? [] : List<LanguageModel>.from(json["data"]!.map((x) => LanguageModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LanguageModel {
  final String? id;
  final String? code;
  final String? name;
  final String? nativeName;
  final bool? isActive;
  final bool? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  LanguageModel({
    this.id,
    this.code,
    this.name,
    this.nativeName,
    this.isActive,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
    id: json["_id"],
    code: json["code"],
    name: json["name"],
    nativeName: json["nativeName"],
    isActive: json["IsActive"],
    isDefault: json["isDefault"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "code": code,
    "name": name,
    "nativeName": nativeName,
    "IsActive": isActive,
    "isDefault": isDefault,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
