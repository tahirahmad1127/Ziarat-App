import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/haram_gates.dart';
import '../models/umrah_masail.dart';

class JsonLoaderService {
  static Future<List<UmrahMasailModel>> loadUmrahMasail() async {
    final String response =
    await rootBundle.loadString('assets/json/umrah_masail_en.json');
    final data = json.decode(response);
    return (data['data'] as List)
        .map((e) => UmrahMasailModel.fromJson(e))
        .toList();
  }

  static Future<List<UmrahMasailModel>> loadHajjMasail() async {
    final String response =
        await rootBundle.loadString('assets/json/hajj_masail.json');
    final decoded = json.decode(response);
    final List<dynamic> list = decoded is List
        ? decoded
        : ((decoded is Map<String, dynamic> ? decoded['data'] : null) as List? ??
            const []);
    return list
        .map((e) => UmrahMasailModel.fromJson(e))
        .toList();
  }

  static Future<List<HaramGateModel>> loadHaramGates() async {
    final String response =
    await rootBundle.loadString('assets/json/haram_gates.json');
    final data = json.decode(response);
    return (data['data'] as List)
        .map((e) => HaramGateModel.fromJson(e))
        .toList();
  }
}