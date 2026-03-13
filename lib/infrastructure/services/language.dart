
import 'package:dartz/dartz.dart';

import '../../../configurations/end_points.dart';
import '../api_helper.dart';
import '../models/error.dart';
import '../models/language.dart';

abstract class LanguageRepository {
  Future<Either<GlobalErrorModel, LanguageModel>> getLanguage();
}

class LanguageRepositoryImp extends LanguageRepository {
  @override
  Future<Either<GlobalErrorModel, LanguageModel>> getLanguage() async {
    var data = await ApiBaseHelper().getEither(
      endPoint: ApiEndPoints.kGetLanguage,
      isRequiredHeader: true,
      header: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },);
    return data.fold((l) {
      return Left(GlobalErrorModel(error: l.error.toString()));
    }, (r) {
      return Right(LanguageModel.fromJson(r));
    });
  }
}
