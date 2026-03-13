import 'package:get/get.dart';

class UmrahMasailModel {
  final int index;
  final String questionEn;
  final String questionAr;
  final String questionUr;
  final String answerEn;
  final String answerAr;
  final String answerUr;

  UmrahMasailModel({
    required this.index,
    required this.questionEn,
    required this.questionAr,
    required this.questionUr,
    required this.answerEn,
    required this.answerAr,
    required this.answerUr,
  });

  factory UmrahMasailModel.fromJson(Map<String, dynamic> json) {
    return UmrahMasailModel(
      index: json['index'],
      questionEn: json['question_en'],
      questionAr: json['question_ar'],
      questionUr: json['question_ur'],
      answerEn: json['answer_en'],
      answerAr: json['answer_ar'],
      answerUr: json['answer_ur'],
    );
  }

  // Auto returns correct language based on locale
  String get localizedQuestion {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ar') return questionAr;
    if (lang == 'ur') return questionUr;
    return questionEn;
  }

  String get localizedAnswer {
    final lang = Get.locale?.languageCode ?? 'en';
    if (lang == 'ar') return answerAr;
    if (lang == 'ur') return answerUr;
    return answerEn;
  }
}