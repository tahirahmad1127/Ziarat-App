import 'package:get/get.dart';
import 'en_US.dart';
import 'ar_SA.dart';
import 'ur_PK.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        ...StringConstantEn().keys,
        ...StringConstantAr().keys,
        ...StringConstantUr().keys,
      };
}
