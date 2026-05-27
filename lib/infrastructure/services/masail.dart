// lib/infrastructure/services/masail.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/masail.dart';

class MasailService {
  static const String _baseUrl = 'https://ziaratapi.vercel.app';

  // ─────────────────────────────────────────────────────────────────────────
  // MASAIL  (Q&A)  — endpoint: GET /api/masail?masailType=...&category=...
  // Response shape: { success, count, data: [{ question_en, answer_en, … }] }
  // ─────────────────────────────────────────────────────────────────────────

  static Future<MasailResponseModel> fetchMasail({
    required String masailType,
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    try {
      final queryParams = {
        'masailType': masailType,
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null && category.isNotEmpty) 'category': category,
      };

      final uri = Uri.parse('$_baseUrl/api/masail')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      _assertJson(response);

      if (response.statusCode == 200) {
        final parsed = MasailResponseModel.fromJson(jsonDecode(response.body));
        // ── Client-side guard: API may ignore query params and return all
        // records. Filter here so Hajj data never leaks into Umrah and vice
        // versa, and so category ("Women Guide" vs "Masail (Q/A)") is also
        // respected even when the server doesn't filter it.
        final filtered = parsed.data.where((item) {
          final typeMatch = item.masailType == masailType;
          final categoryMatch =
              category == null || category.isEmpty || item.category == category;
          return typeMatch && categoryMatch;
        }).toList();
        return MasailResponseModel(
          success: parsed.success,
          count: filtered.length,
          data: filtered,
        );
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found (404)');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized (401)');
      } else {
        throw Exception(
            'Failed to load masail: ${response.statusCode}\n${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching masail: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COMMON MISTAKES — endpoint: GET /api/common-mistakes?category=Hajj|Umrah
  // Response shape: { success, count, data: [{ title:{en,ur,ar}, content:{en,ur,ar} }] }
  //
  // NOTE: This is a DIFFERENT endpoint and schema from the masail Q&A endpoint.
  // ─────────────────────────────────────────────────────────────────────────

  static Future<CommonMistakeResponseModel> fetchCommonMistakes({
    required String category, // "Hajj" or "Umrah"
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/common-mistakes').replace(
        queryParameters: {
          'category': category,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      _assertJson(response);

      if (response.statusCode == 200) {
        final parsed =
        CommonMistakeResponseModel.fromJson(jsonDecode(response.body));
        // ── Client-side guard: API returns all categories regardless of the
        // ?category= param. Filter here so Umrah mistakes never show in Hajj
        // and vice versa.
        final filtered = parsed.data
            .where((item) => item.category == category)
            .toList();
        return CommonMistakeResponseModel(
          success: parsed.success,
          count: filtered.length,
          data: filtered,
        );
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found (404)');
      } else {
        throw Exception(
            'Failed to load common mistakes: ${response.statusCode}\n${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching common mistakes: $e');
    }
  }

  // ── Umrah ──────────────────────────────────────────────────────────────────

  static Future<MasailResponseModel> fetchUmrahMasail({
    int page = 1,
    int limit = 10,
    String? category,
  }) =>
      fetchMasail(
        masailType: 'Umrah Masail',
        page: page,
        limit: limit,
        category: category,
      );

  /// Fetches Umrah-specific common mistakes from /api/common-mistakes?category=Umrah
  static Future<CommonMistakeResponseModel> fetchUmrahCommonMistakes({
    int page = 1,
    int limit = 10,
  }) =>
      fetchCommonMistakes(category: 'Umrah', page: page, limit: limit);

  static Future<MasailResponseModel> fetchUmrahWomensGuide({
    int page = 1,
    int limit = 10,
    String? category,
  }) =>
      fetchMasail(
        masailType: 'Umrah Masail',
        page: page,
        limit: limit,
        category: category,
      );

  // ── Hajj ───────────────────────────────────────────────────────────────────

  static Future<MasailResponseModel> fetchHajjMasail({
    int page = 1,
    int limit = 10,
    String? category,
  }) =>
      fetchMasail(
        masailType: 'Hajj Masail',
        page: page,
        limit: limit,
        category: category,
      );

  /// Fetches Hajj-specific common mistakes from /api/common-mistakes?category=Hajj
  static Future<CommonMistakeResponseModel> fetchHajjCommonMistakes({
    int page = 1,
    int limit = 10,
  }) =>
      fetchCommonMistakes(category: 'Hajj', page: page, limit: limit);

  static Future<MasailResponseModel> fetchHajjWomensGuide({
    int page = 1,
    int limit = 10,
    String? category,
  }) =>
      fetchMasail(
        masailType: 'Hajj Masail',
        page: page,
        limit: limit,
        category: category,
      );

  // ── Search (client-side, Masail Q&A only) ─────────────────────────────────

  static Future<MasailResponseModel> searchMasail({
    required String query,
    String? masailType,
  }) async {
    final type = masailType ?? 'Umrah Masail';
    final q = query.toLowerCase().trim();
    final List<MasailModel> allItems = [];

    int currentPage = 1;
    const fetchLimit = 50;
    while (true) {
      final response = await fetchMasail(
        masailType: type,
        page: currentPage,
        limit: fetchLimit,
      );
      allItems.addAll(response.data);
      if (response.data.length < fetchLimit) break;
      currentPage++;
    }

    final filtered = allItems.where((item) {
      return item.questionEn.toLowerCase().contains(q) ||
          item.questionUr.contains(q) ||
          item.questionAr.contains(q) ||
          item.answerEn.toLowerCase().contains(q) ||
          item.answerUr.contains(q) ||
          item.answerAr.contains(q);
    }).toList();

    return MasailResponseModel(
      success: true,
      count: filtered.length,
      data: filtered,
    );
  }

  // ── Single masail item ─────────────────────────────────────────────────────

  static Future<MasailModel> fetchMasailById(String id) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/masail/$id');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return MasailModel.fromJson(json['data'] ?? json);
      } else {
        throw Exception('Failed to load masail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching masail: $e');
    }
  }

  // ── Internal helpers ───────────────────────────────────────────────────────

  static void _assertJson(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.contains('application/json')) {
      throw Exception(
        'Unexpected response type: $contentType '
            '(status ${response.statusCode}). '
            'Check your API base URL in MasailService.',
      );
    }
  }
}