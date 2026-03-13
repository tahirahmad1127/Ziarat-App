
import 'package:dartz/dartz.dart';
import 'package:ziarat_app/infrastructure/models/privacy_policy.dart';

import '../../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';

abstract class PrivacyPolicyRepository {
  Future<Either<GlobalErrorModel, PrivacyPolicyModel>> getPrivacyPolicy();
}

class PrivacyPolicyRepositoryImp extends PrivacyPolicyRepository {
  @override
  Future<Either<GlobalErrorModel, PrivacyPolicyModel>> getPrivacyPolicy() async {
    var data = await ApiBaseHelper().getEither(
        endPoint: ApiEndPoints.kGetPrivacyPolicy,
        isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },);
    return data.fold((l) {
      return Left(GlobalErrorModel(error: l.error.toString()));
    }, (r) {
      return Right(PrivacyPolicyModel.fromJson(r));
    });
  }
}
