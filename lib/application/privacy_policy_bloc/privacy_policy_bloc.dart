import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziarat_app/infrastructure/models/privacy_policy.dart';

import '../../infrastructure/services/privacy_policy.dart';

part 'privacy_policy_event.dart';

part 'privacy_policy_state.dart';

class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final PrivacyPolicyRepositoryImp repositoryImp;

  PrivacyPolicyBloc(this.repositoryImp) : super(PrivacyPolicyInitial()) {
    on<PrivacyPolicyEvent>((event, emit) async {
      if (event is GetPrivacyPolicyEvent) {
        try {
          emit(PrivacyPolicyLoading());

          final failureOrSuccess = await repositoryImp.getPrivacyPolicy();
          failureOrSuccess.fold((l) => emit(PrivacyPolicyFailed(l.error.toString())),
              (r) {
            return emit(PrivacyPolicyLoaded(r));
          });
        } catch (e) {
          log("BLOC ERROR: $e");
          emit(PrivacyPolicyFailed(e.toString()));
        }
      }
    });
  }
}
