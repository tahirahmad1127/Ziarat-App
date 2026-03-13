import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziarat_app/infrastructure/models/privacy_policy.dart';
import 'package:ziarat_app/infrastructure/models/terms_condition.dart';

import '../../infrastructure/services/privacy_policy.dart';
import '../../infrastructure/services/terms_conditions.dart';

part 'terms_conditions_event.dart';

part 'terms_conditions_state.dart';

class TermsConditionsBloc extends Bloc<TermsConditionsEvent, TermsConditionsState> {
  final TermsConditionsRepositoryImp repositoryImp;

  TermsConditionsBloc(this.repositoryImp) : super(TermsConditionsInitial()) {
    on<TermsConditionsEvent>((event, emit) async {
      if (event is GetTermsConditionsEvent) {
        try {
          emit(TermsConditionsLoading());

          final failureOrSuccess = await repositoryImp.getTermsConditions();
          failureOrSuccess.fold((l) => emit(TermsConditionsFailed(l.error.toString())),
                  (r) {
                return emit(TermsConditionsLoaded(r));
              });
        } catch (e) {
          rethrow;
        }
      }
    });
  }
}
