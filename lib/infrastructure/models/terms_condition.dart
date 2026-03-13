// To parse this JSON data, do
//
//     final termsConditionsModel = termsConditionsModelFromJson(jsonString);

import 'dart:convert';

TermsConditionsModel termsConditionsModelFromJson(String str) => TermsConditionsModel.fromJson(json.decode(str));

String termsConditionsModelToJson(TermsConditionsModel data) => json.encode(data.toJson());

class TermsConditionsModel {
  final bool? success;
  final Data? data;

  TermsConditionsModel({
    this.success,
    this.data,
  });

  factory TermsConditionsModel.fromJson(Map<String, dynamic> json) => TermsConditionsModel(
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
  final String? content;
  final bool? isActive;
  final String? version;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Data({
    this.id,
    this.type,
    this.title,
    this.content,
    this.isActive,
    this.version,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    type: json["type"],
    title: json["title"],
    content: json["Content"],
    isActive: json["IsActive"],
    version: json["version"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "type": type,
    "title": title,
    "Content": content,
    "IsActive": isActive,
    "version": version,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
