
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
  @override
  Future<Either<GlobalErrorModel, SimProviderListingModel>> getSimProviders() async {
    var data = await ApiBaseHelper().getEither(
        endPoint: ApiEndPoints.kGetSimProviders,
        isRequiredHeader: true,
        header: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        });
    return data.fold((l) {
      return Left(GlobalErrorModel(error: l.error.toString()));
    }, (r) {
      return Right(SimProviderListingModel.fromJson(r));
    });
  }

  @override
  Future<Either<GlobalErrorModel, PackageListingModel>> getPackagesBySimId(String simId) async {
    var data = await ApiBaseHelper().getEither(
        endPoint: ApiEndPoints.kGetPackagesByProviders + simId,
        isRequiredHeader: true,
        header: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',

        });
    return data.fold((l) {
      return Left(GlobalErrorModel(error: l.error.toString()));
    }, (r) {
      return Right(PackageListingModel.fromJson(r));
    });
  }
}
