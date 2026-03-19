import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ziarat_app/infrastructure/models/packages.dart';
import 'package:ziarat_app/infrastructure/models/sim_provider.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';

abstract class SimProviderRepository {
  Future<Either<GlobalErrorModel, SimProviderListingModel>> getSimProviders();
  Future<Either<GlobalErrorModel, PackageListingModel>> getPackagesBySimId(String simId);
}

class SimProviderRepositoryImp extends SimProviderRepository {

  SimProviderListingModel? _simProvidersCache;
  final Map<String, PackageListingModel> _packagesCache = {};

  void clearCache() {
    _simProvidersCache = null;
    _packagesCache.clear();
  }

  /// Normalize to Map<String, dynamic> regardless of what ApiBaseHelper returns
  Map<String, dynamic> _toMap(dynamic r) {
    if (r is Map<String, dynamic>) return r;
    if (r is String) return jsonDecode(r) as Map<String, dynamic>;
    return jsonDecode(jsonEncode(r)) as Map<String, dynamic>;
  }

  /// Normalize each list item to Map<String, dynamic>
  Map<String, dynamic> _itemToMap(dynamic item) {
    if (item is Map<String, dynamic>) return item;
    if (item is String) return jsonDecode(item) as Map<String, dynamic>;
    return jsonDecode(jsonEncode(item)) as Map<String, dynamic>;
  }

  @override
  Future<Either<GlobalErrorModel, SimProviderListingModel>> getSimProviders() async {
    if (_simProvidersCache != null) {
      return Right(_simProvidersCache!);
    }

    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetSimProviders,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        final map = _toMap(r);
        final list = (map['data'] as List<dynamic>?) ?? [];
        final providers = list.map((e) => SimProviderModel.fromJson(_itemToMap(e))).toList();
        _simProvidersCache = SimProviderListingModel(
          success: map['success'] as bool?,
          count: map['count'] as int?,
          data: providers,
        );
        return Right(_simProvidersCache!);
      },
    );
  }

  @override
  Future<Either<GlobalErrorModel, PackageListingModel>> getPackagesBySimId(
      String simId) async {
    if (_packagesCache.containsKey(simId)) {
      return Right(_packagesCache[simId]!);
    }

    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetPackagesByProviders + simId,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        final map = _toMap(r);
        final list = (map['data'] as List<dynamic>?) ?? [];
        final packages = list.map((e) => PackageModel.fromJson(_itemToMap(e))).toList();
        _packagesCache[simId] = PackageListingModel(
          success: map['success'] as bool?,
          count: map['count'] as int?,
          data: packages,
        );
        return Right(_packagesCache[simId]!);
      },
    );
  }
}