import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/application/sim_provider_bloc/sim_provider_bloc.dart';
import 'package:ziarat_app/infrastructure/models/sim_provider.dart';
import 'package:ziarat_app/presentation/views/sim/package_details.dart';
import '../../../../injection_container.dart';
import '../../../processing_widget.dart';
import '../../../constants/app_strings.dart';

class PackageDetailsViewBody extends StatelessWidget {
  final SimProviderModel provider;

  const PackageDetailsViewBody({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SimProviderBloc>()
        ..add(GetPackagesEvent(id: provider.id ?? '')),
      child: BlocBuilder<SimProviderBloc, SimProviderState>(
        builder: (context, state) {
          if (state is SimProviderInitial || state is SimProviderLoading) {
            return const Center(child: ProcessingWidget());
          } else if (state is PackagesLoaded) {
            return PackageDetails(
              provider: provider,
              packages: state.model.data ?? [],
            );
          } else if (state is SimProviderFailed) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text(AppStrings.genericSomethingWentWrongTxt.tr));
          }
        },
      ),
    );
  }
}