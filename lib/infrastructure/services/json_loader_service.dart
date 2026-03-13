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

  static Future<List<HaramGateModel>> loadHaramGates() async {
    final String response =
    await rootBundle.loadString('assets/json/haram_gates.json');
    final data = json.decode(response);
    return (data['data'] as List)
        .map((e) => HaramGateModel.fromJson(e))
        .toList();
  }
}