import 'package:dartz/dartz.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';
import '../models/umrah_travel_docs.dart';

abstract class UmrahTravelRepository {
  Future<Either<GlobalErrorModel, UmrahTravelModel>> getUmrahTravelDocs();
}

class UmrahTravelRepositoryImp extends UmrahTravelRepository {
  UmrahTravelModel? _cache;

  void clearCache() => _cache = null;

  @override
  Future<Either<GlobalErrorModel, UmrahTravelModel>>
  getUmrahTravelDocs() async {
    if (_cache != null) return Right(_cache!);

    final data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetUmrahTravelDocs,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        _cache = UmrahTravelModel.fromJson(r);
        return Right(_cache!);
      },
    );
  }
}