import 'package:dartz/dartz.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';
import '../models/umrah_saman.dart';

abstract class UmrahSamanRepository {
  Future<Either<GlobalErrorModel, UmrahSamanModel>> getUmrahSaman();
}

class UmrahSamanRepositoryImp extends UmrahSamanRepository {
  UmrahSamanModel? _cache;

  void clearCache() => _cache = null;

  @override
  Future<Either<GlobalErrorModel, UmrahSamanModel>> getUmrahSaman() async {
    if (_cache != null) return Right(_cache!);

    final data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetUmrahSaman,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return data.fold(
          (l) => Left(GlobalErrorModel(error: l.error.toString())),
          (r) {
        _cache = UmrahSamanModel.fromJson(r);
        return Right(_cache!);
      },
    );
  }
}