// To parse this JSON data, do
//
//     final simProviderListingModel = simProviderListingModelFromJson(jsonString);

import 'dart:convert';

SimProviderListingModel simProviderListingModelFromJson(String str) => SimProviderListingModel.fromJson(json.decode(str));

String simProviderListingModelToJson(SimProviderListingModel data) => json.encode(data.toJson());

class SimProviderListingModel {
  final bool? success;
  final int? count;
  final List<SimProviderModel>? data;

  SimProviderListingModel({
    this.success,
    this.count,
    this.data,
  });

  factory SimProviderListingModel.fromJson(Map<String, dynamic> json) => SimProviderListingModel(
    success: json["success"],
    count: json["count"],
    data: json["data"] == null ? [] : List<SimProviderModel>.from(json["data"]!.map((x) => SimProviderModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SimProviderModel {
  final String? id;
  final String? image;
  final String? title;
  final String? description;
  final String? helplineNumber;
  final String? providerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  SimProviderModel({
    this.id,
    this.image,
    this.title,
    this.description,
    this.helplineNumber,
    this.providerId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SimProviderModel.fromJson(Map<String, dynamic> json) => SimProviderModel(
    id: json["_id"],
    image: json["Image"],
    title: json["Title"],
    description: json["Description"],
    helplineNumber: json["HelplineNumber"],
    providerId: json["ProviderID"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "Image": image,
    "Title": title,
    "Description": description,
    "HelplineNumber": helplineNumber,
    "ProviderID": providerId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
