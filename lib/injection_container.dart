import 'package:get_it/get_it.dart';
import 'package:ziarat_app/application/privacy_policy_bloc/privacy_policy_bloc.dart';
import 'package:ziarat_app/application/sim_provider_bloc/sim_provider_bloc.dart';
import 'package:ziarat_app/application/terms_conditions_bloc/terms_conditions_bloc.dart';
import 'package:ziarat_app/application/ziarat_bloc/ziarat_bloc.dart';
import 'package:ziarat_app/infrastructure/services/privacy_policy.dart';
import 'package:ziarat_app/infrastructure/services/sim_provider.dart';
import 'package:ziarat_app/infrastructure/services/terms_conditions.dart';
import 'package:ziarat_app/infrastructure/services/ziarat.dart';


final sl = GetIt.instance;

Future<void> init() async {
  ///Blocs
  sl.registerFactory<PrivacyPolicyBloc>(() => PrivacyPolicyBloc(sl()));
  sl.registerFactory<TermsConditionsBloc>(() => TermsConditionsBloc(sl()));
  sl.registerFactory<SimProviderBloc>(() => SimProviderBloc(sl()));
  sl.registerFactory<ZiaratBloc>(() => ZiaratBloc(sl()));


  ///Services
   sl.registerLazySingleton(() => PrivacyPolicyRepositoryImp());
   sl.registerLazySingleton(() => TermsConditionsRepositoryImp());
   sl.registerLazySingleton(() => SimProviderRepositoryImp());
   sl.registerLazySingleton(() => ZiaratRepositoryImp());

}