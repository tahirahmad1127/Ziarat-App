// To parse this JSON data, do
//
//     final globalErrorModel = globalErrorModelFromJson(jsonString);

import 'dart:convert';

GlobalErrorModel globalErrorModelFromJson(String str) => GlobalErrorModel.fromJson(json.decode(str));

String globalErrorModelToJson(GlobalErrorModel data) => json.encode(data.toJson());

class GlobalErrorModel {
  final String? error;

  GlobalErrorModel({
    this.error,
  });

  factory GlobalErrorModel.fromJson(Map<String, dynamic> json) => GlobalErrorModel(
    error: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": error,
  };
}
