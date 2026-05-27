import 'package:dartz/dartz.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';
import '../models/hajj_saman.dart';

abstract class HajjSamanRepository {
  Future<Either<GlobalErrorModel, HajjSamanModel>> getHajjSaman();
}

class HajjSamanRepositoryImp extends HajjSamanRepository {
  HajjSamanModel? _cache;

  void clearCache() => _cache = null;

  @override
  Future<Either<GlobalErrorModel, HajjSamanModel>> getHajjSaman() async {
    if (_cache != null) return Right(_cache!);

    final data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetHajjSaman,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        _cache = HajjSamanModel.fromJson(r);
        return Right(_cache!);
      },
    );
  }
}