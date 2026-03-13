import 'package:dartz/dartz.dart';

import 'package:ziarat_app/infrastructure/models/terms_condition.dart';

import '../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';

abstract class TermsConditionsRepository {
  Future<Either<GlobalErrorModel, TermsConditionsModel>> getTermsConditions();
}

class TermsConditionsRepositoryImp extends TermsConditionsRepository {
  @override
  Future<Either<GlobalErrorModel, TermsConditionsModel>>
  getTermsConditions() async {
    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetTermsConditions,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },    );
    return data.fold(
      (l) {
        return Left(GlobalErrorModel(error: l.error.toString()));
      },
      (r) {
        return Right(TermsConditionsModel.fromJson(r));
      },
    );
  }
}
