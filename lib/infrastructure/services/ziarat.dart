import 'package:dartz/dartz.dart';
import 'package:ziarat_app/infrastructure/models/ziarat.dart';
import 'package:ziarat_app/infrastructure/models/ziarat_details.dart';

import '../../configurations/back_end_configs.dart';
import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';

abstract class ZiaratRepository {
  Future<Either<GlobalErrorModel, ZiaratListingModel>> getMadinaZiarat();

  Future<Either<GlobalErrorModel, ZiaratListingModel>> getMakkahZiarat();

  Future<Either<GlobalErrorModel, ZiaratListingModel>> searchZiarat(
    String searchKey,
  );

  Future<Either<GlobalErrorModel, ZiaratDetailModel>> getZiaratDetail(
    String ziaratId,
  );
}

class ZiaratRepositoryImp extends ZiaratRepository {
  @override
  Future<Either<GlobalErrorModel, ZiaratListingModel>> getMadinaZiarat() async {
    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetMadinaZiarat,
      isRequiredHeader: true,
      header: {'Accept': '*/*'},
    );
    return data.fold(
      (l) {
        return Left(GlobalErrorModel(error: l.error.toString()));
      },
      (r) {
        return Right(ZiaratListingModel.fromJson(r));
      },
    );
  }

  @override
  Future<Either<GlobalErrorModel, ZiaratListingModel>> getMakkahZiarat() async {
    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetMakkahZiarat,
      isRequiredHeader: true,
      header: {'Accept': '*/*'},
    );
    return data.fold(
      (l) {
        return Left(GlobalErrorModel(error: l.error.toString()));
      },
      (r) {
        return Right(ZiaratListingModel.fromJson(r));
      },
    );
  }

  @override
  Future<Either<GlobalErrorModel, ZiaratDetailModel>> getZiaratDetail(
    String ziaratId,
  ) async {
    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetMadinaZiarat,
      isRequiredHeader: true,
      header: {'Accept': '*/*'},
    );
    return data.fold(
      (l) {
        return Left(GlobalErrorModel(error: l.error.toString()));
      },
      (r) {
        return Right(ZiaratDetailModel.fromJson(r));
      },
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
