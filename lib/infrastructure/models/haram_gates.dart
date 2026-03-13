import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HaramGateModel {
  final int index;
  final int gateNo;
  final String englishName;
  final String arabicName;
  final String descriptionEn;
  final String descriptionAr;
  final String descriptionUr;

  HaramGateModel({
    required this.index,
    required this.gateNo,
    required this.englishName,
    required this.arabicName,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.descriptionUr,
  });

  factory HaramGateModel.fromJson(Map<String, dynamic> json) {
    return HaramGateModel(
      index: json['index'],
      gateNo: json['gate_no'],
      englishName: json['english_name'],
      arabicName: json['arabic_name'],
      descriptionEn: json['description_en'],
      descriptionAr: json['description_ar'],
      descriptionUr: json['description_ur'],
    );
  }

  // Returns correct description based on current locale
  String get localizedDescription {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ar') return descriptionAr;
    if (lang == 'ur') return descriptionUr;
    return descriptionEn;
  }

  // Returns correct name based on current locale
  String get localizedName {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ar' || lang == 'ur') return arabicName;
    return englishName;
  }
}