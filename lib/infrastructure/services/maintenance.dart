import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/maintenance.dart';

class MaintenanceService {
  static const String _collectionName = 'maintenanceCollection';
  static const String _documentId = 'isPAcFyDahoEtSd3KJ0g';

  final FirebaseFirestore _firestore;

  MaintenanceService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Returns a real-time stream of [MaintenanceModel].
  /// [isEnabled] == true  → show MaintenanceScreen
  /// [isEnabled] == false → proceed normally
  Stream<MaintenanceModel> get maintenanceStream {
    return _firestore
        .collection(_collectionName)
        .doc(_documentId)
        .snapshots()
        .map((snapshot) {
      log('📦 From cache: ${snapshot.metadata.isFromCache}');
      log('📦 Data: ${snapshot.data()}');

      if (!snapshot.exists || snapshot.data() == null) {
        // Document missing → treat app as NOT under maintenance
        return const MaintenanceModel(isEnabled: false);
      }
      return MaintenanceModel.fromMap(snapshot.data()!);
    });
  }

  /// Forces a fresh fetch directly from Firestore server (bypasses cache).
  Future<MaintenanceModel> getMaintenanceStatus() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .doc(_documentId)
          .get(const GetOptions(source: Source.server));

      log('✅ Server fetch successful');
      log('📦 Data: ${snapshot.data()}');

      if (!snapshot.exists || snapshot.data() == null) {
        return const MaintenanceModel(isEnabled: false);
      }
      return MaintenanceModel.fromMap(snapshot.data()!);
    } catch (e) {
      // If server fetch fails (e.g. no internet), fall back to cache
      log('⚠️ Server fetch failed, falling back to cache: $e');
      final snapshot = await _firestore
          .collection(_collectionName)
          .doc(_documentId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return const MaintenanceModel(isEnabled: false);
      }
      return MaintenanceModel.fromMap(snapshot.data()!);
    }
  }
}