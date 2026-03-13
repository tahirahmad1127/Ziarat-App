import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziarat_app/infrastructure/models/ziarat.dart';
import 'package:flutter/material.dart';
import '../../infrastructure/models/ziarat_details.dart';
import '../../infrastructure/services/ziarat.dart';

part 'ziarat_event.dart';

part 'ziarat_state.dart';

class ZiaratBloc extends Bloc<ZiaratEvent, ZiaratState> {
  final ZiaratRepositoryImp repositoryImp;

  ZiaratBloc(this.repositoryImp) : super(ZiaratInitial()) {
    on<ZiaratEvent>((event, emit) async {
      if (event is GetMakkahZiaratEvent) {
        try {
          emit(ZiaratLoading());

          final failureOrSuccess = await repositoryImp.getMakkahZiarat();
          failureOrSuccess.fold((l) => emit(ZiaratFailed(l.error.toString())),
                  (r) {
                return emit(ZiaratLoaded(r));
              });
        } catch (e) {
          rethrow;
        }
      }
      else if (event is GetMadinaZiaratEvent) {
        try {
          emit(ZiaratLoading());

          final failureOrSuccess = await repositoryImp.getMadinaZiarat();
          failureOrSuccess.fold((l) => emit(ZiaratFailed(l.error.toString())),
                  (r) {
                return emit(ZiaratLoaded(r));
              });
        } catch (e) {
          rethrow;
        }
      }


      else if (event is GetZiaratDetailsEvent) {
        try {
          emit(ZiaratLoading());

          final failureOrSuccess = await repositoryImp.getZiaratDetail(event.key);
          failureOrSuccess.fold((l) => emit(ZiaratFailed(l.error.toString())),
                  (r) {
                return emit(ZiaratDetailsLoaded(r));
              });
        } catch (e) {
          rethrow;
        }
      }


      else if (event is SearchZiaratEvent) {
        try {
          emit(ZiaratLoading());
          final failureOrSuccess = await repositoryImp.searchZiarat(event.keyword);
          failureOrSuccess.fold(
                (l) => emit(ZiaratFailed(l.error.toString())),
                (r) => emit(ZiaratSearchLoaded(r)), // 👈 different state
          );
        } catch (e) {
          rethrow;
        }
      }
    });
  }

}