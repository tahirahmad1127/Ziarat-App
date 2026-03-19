import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziarat_app/infrastructure/models/packages.dart';

import '../../infrastructure/models/sim_provider.dart';
import '../../infrastructure/services/sim_provider.dart';

part 'sim_provider_event.dart';
part 'sim_provider_state.dart';

class SimProviderBloc extends Bloc<SimProviderEvent, SimProviderState> {
  final SimProviderRepositoryImp repositoryImp;

  SimProviderBloc(this.repositoryImp) : super(SimProviderInitial()) {
    on<SimProviderEvent>((event, emit) async {
      if (event is GetSimProviderEvent) {
        try {
          emit(SimProviderLoading());
          final failureOrSuccess = await repositoryImp.getSimProviders();
          failureOrSuccess.fold(
                (l) => emit(SimProviderFailed(l.error.toString())),
                (r) => emit(SimProviderLoaded(r)),
          );
        } catch (e) {
          emit(SimProviderFailed(e.toString()));
        }
      } else if (event is GetPackagesEvent) {
        try {
          emit(SimProviderLoading());
          final failureOrSuccess = await repositoryImp.getPackagesBySimId(event.id);
          failureOrSuccess.fold(
                (l) => emit(SimProviderFailed(l.error.toString())),
                (r) => emit(PackagesLoaded(r)),
          );
        } catch (e) {
          emit(SimProviderFailed(e.toString()));
        }
      }
    });
  }
}