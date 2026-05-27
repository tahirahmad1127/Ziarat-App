import 'package:dartz/dartz.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';
import '../models/hajj_travel_docs.dart';

abstract class HajjTravelRepository {
  Future<Either<GlobalErrorModel, HajjTravelModel>> getHajjTravelDocs();
}

class HajjTravelRepositoryImp extends HajjTravelRepository {
  HajjTravelModel? _cache;

  void clearCache() => _cache = null;

  @override
  Future<Either<GlobalErrorModel, HajjTravelModel>> getHajjTravelDocs() async {
    if (_cache != null) return Right(_cache!);

    final data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetHajjTravelDocs,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        _cache = HajjTravelModel.fromJson(r);
        return Right(_cache!);
      },
    );
  }
}