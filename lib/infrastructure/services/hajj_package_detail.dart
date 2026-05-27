import 'package:dartz/dartz.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';
import '../models/hajj_package_details.dart';

abstract class HajjPackageDetailRepository {
  Future<Either<GlobalErrorModel, HajjPackageDetailModel>> getHajjPackageDetail();
}

class HajjPackageDetailRepositoryImp extends HajjPackageDetailRepository {
  HajjPackageDetailModel? _cache;

  void clearCache() => _cache = null;

  @override
  Future<Either<GlobalErrorModel, HajjPackageDetailModel>>
  getHajjPackageDetail() async {
    if (_cache != null) return Right(_cache!);

    final data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetHajjPackageDetail,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        _cache = HajjPackageDetailModel.fromJson(r);
        return Right(_cache!);
      },
    );
  }
}