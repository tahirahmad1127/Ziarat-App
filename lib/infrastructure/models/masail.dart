// lib/infrastructure/models/masail.dart

class MasailModel {
  final String id;
  final String masailType; // "Hajj Masail", "Umrah Masail", etc.
  final String category; // "Ihram", "Tawaf", etc.
  final String questionEn;
  final String questionUr;
  final String questionAr;
  final String answerEn;
  final String answerUr;
  final String answerAr;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MasailModel({
    required this.id,
    required this.masailType,
    required this.category,
    required this.questionEn,
    required this.questionUr,
    required this.questionAr,
    required this.answerEn,
    required this.answerUr,
    required this.answerAr,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get localized question based on current language
  String getLocalizedQuestion(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return questionAr;
      case 'ur':
        return questionUr;
      default:
        return questionEn;
    }
  }

  /// Get localized answer based on current language
  String getLocalizedAnswer(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return answerAr;
      case 'ur':
        return answerUr;
      default:
        return answerEn;
    }
  }

  factory MasailModel.fromJson(Map<String, dynamic> json) {
    return MasailModel(
      id: json['_id'] ?? '',
      masailType: json['masailType'] ?? '',
      category: json['category'] ?? '',
      questionEn: json['question_en'] ?? '',
      questionUr: json['question_ur'] ?? '',
      questionAr: json['question_ar'] ?? '',
      answerEn: json['answer_en'] ?? '',
      answerUr: json['answer_ur'] ?? '',
      answerAr: json['answer_ar'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'masailType': masailType,
      'category': category,
      'question_en': questionEn,
      'question_ur': questionUr,
      'question_ar': questionAr,
      'answer_en': answerEn,
      'answer_ur': answerUr,
      'answer_ar': answerAr,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Response model for API pagination
class MasailResponseModel {
  final bool success;
  final int count;
  final List<MasailModel> data;

  MasailResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory MasailResponseModel.fromJson(Map<String, dynamic> json) {
    return MasailResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List?)
          ?.map((item) => MasailModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CommonMistakeModel — matches the /api/common-mistakes response schema:
//   { title: {en, ur, ar}, content: {en, ur, ar}, category: "Hajj"|"Umrah" }
//
// It also exposes the same getLocalizedQuestion / getLocalizedAnswer helpers
// so it can be used interchangeably with MasailModel in the bottom-sheet.
// ─────────────────────────────────────────────────────────────────────────────

class CommonMistakeModel {
  final String id;
  final String category; // "Hajj" or "Umrah"
  final String titleEn;
  final String titleUr;
  final String titleAr;
  final String contentEn;
  final String contentUr;
  final String contentAr;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommonMistakeModel({
    required this.id,
    required this.category,
    required this.titleEn,
    required this.titleUr,
    required this.titleAr,
    required this.contentEn,
    required this.contentUr,
    required this.contentAr,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Mirrors MasailModel.getLocalizedQuestion so UI widgets stay uniform.
  String getLocalizedQuestion(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return titleAr;
      case 'ur':
        return titleUr;
      default:
        return titleEn;
    }
  }

  /// Mirrors MasailModel.getLocalizedAnswer so UI widgets stay uniform.
  String getLocalizedAnswer(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return contentAr;
      case 'ur':
        return contentUr;
      default:
        return contentEn;
    }
  }

  factory CommonMistakeModel.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as Map<String, dynamic>? ?? {};
    final content = json['content'] as Map<String, dynamic>? ?? {};
    return CommonMistakeModel(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      titleEn: title['en'] ?? '',
      titleUr: title['ur'] ?? '',
      titleAr: title['ar'] ?? '',
      contentEn: content['en'] ?? '',
      contentUr: content['ur'] ?? '',
      contentAr: content['ar'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

/// Response model for common mistakes pagination
class CommonMistakeResponseModel {
  final bool success;
  final int count;
  final List<CommonMistakeModel> data;

  CommonMistakeResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory CommonMistakeResponseModel.fromJson(Map<String, dynamic> json) {
    return CommonMistakeResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List?)
          ?.map((item) =>
          CommonMistakeModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}