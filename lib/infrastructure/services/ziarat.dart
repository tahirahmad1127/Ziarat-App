import 'package:dartz/dartz.dart';
import 'package:ziarat_app/infrastructure/models/ziarat.dart';
import 'package:ziarat_app/infrastructure/models/ziarat_details.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';

abstract class ZiaratRepository {
  Future<Either<GlobalErrorModel, ZiaratListingModel>> getMadinaZiarat();
  Future<Either<GlobalErrorModel, ZiaratListingModel>> getMakkahZiarat();
  Future<Either<GlobalErrorModel, ZiaratListingModel>> searchZiarat(String searchKey);
  Future<Either<GlobalErrorModel, ZiaratDetailModel>> getZiaratDetail(String ziaratId);
}

class ZiaratRepositoryImp extends ZiaratRepository {

  // ── In-memory cache ────────────────────────────────────────────────────────
  ZiaratListingModel? _makkahCache;
  ZiaratListingModel? _madinaCache;

  // Call this if you ever want to force a fresh fetch (e.g. pull-to-refresh)
  void clearCache() {
    _makkahCache = null;
    _madinaCache = null;
  }

  @override
  Future<Either<GlobalErrorModel, ZiaratListingModel>> getMakkahZiarat() async {
    if (_makkahCache != null) {
      return Right(_makkahCache!);
    }

    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetMakkahZiarat,
      isRequiredHeader: true,
      header: {'Accept': '*/*'},
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        _makkahCache = ZiaratListingModel.fromJson(r);
        return Right(_makkahCache!);
      },
    );
  }

  @override
  Future<Either<GlobalErrorModel, ZiaratListingModel>> getMadinaZiarat() async {
    if (_madinaCache != null) {
      return Right(_madinaCache!);
    }

    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetMadinaZiarat,
      isRequiredHeader: true,
      header: {'Accept': '*/*'},
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        _madinaCache = ZiaratListingModel.fromJson(r);
        return Right(_madinaCache!);
      },
    );
  }

  @override
  Future<Either<GlobalErrorModel, ZiaratDetailModel>> getZiaratDetail(
      String ziaratId,
      ) async {
    // ✅ Fixed: correct endpoint with ziarat ID
    var data = await ApiBaseHelper().getEither(
      endPoint: "${ApiEndPoints.kGetZiaratDetails}$ziaratId",
      isRequiredHeader: true,
      header: {'Accept': '*/*'},
    );
    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) => Right(ZiaratDetailModel.fromJson(r)),
    );
  }

  @override
  Future<Either<GlobalErrorModel, ZiaratListingModel>> searchZiarat(
      String searchKey,
      ) async {
    var data = await ApiBaseHelper().getEither(
      endPoint: "${ApiEndPoints.kSearchZiarat}?q=${Uri.encodeComponent(searchKey)}",
      isRequiredHeader: true,
      header: {'Accept': '*/*'},
    );
    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) => Right(ZiaratListingModel.fromJson(r)),
    );
  }
}