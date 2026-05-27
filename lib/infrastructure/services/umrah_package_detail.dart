import 'package:dartz/dartz.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';
import '../models/umrah_package_details.dart';

abstract class UmrahPackageDetailRepository {
  Future<Either<GlobalErrorModel, UmrahPackageDetailModel>> getUmrahPackageDetail();
}

class UmrahPackageDetailRepositoryImp extends UmrahPackageDetailRepository {
  UmrahPackageDetailModel? _cache;

  void clearCache() => _cache = null;

  @override
  Future<Either<GlobalErrorModel, UmrahPackageDetailModel>>
  getUmrahPackageDetail() async {
    if (_cache != null) return Right(_cache!);

    final data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetUmrahPackageDetail,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        _cache = UmrahPackageDetailModel.fromJson(r);
        return Right(_cache!);
      },
    );
  }
}