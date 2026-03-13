import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../application/sim_provider_bloc/sim_provider_bloc.dart';
import '../../../../injection_container.dart';
import '../../../processing_widget.dart';
import '../../../constants/app_strings.dart';
import '../network_provider.dart';

class SimProviderViewBody extends StatelessWidget {
  const SimProviderViewBody({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => sl<SimProviderBloc>(),
      child: BlocBuilder<SimProviderBloc, SimProviderState>(
        builder: (context, state) {
          if (state is SimProviderInitial) {
            BlocProvider.of<SimProviderBloc>(context).add(const GetSimProviderEvent());
            return const Center(
              child: ProcessingWidget(),
            );
          } else if (state is SimProviderLoading) {
            return const Center(
              child: ProcessingWidget(),
            );
          } else if (state is SimProviderLoaded) {
            return NetworkProvider(providers: state.model.data ?? []);
          }
          else if (state is SimProviderFailed) {
            return Center(
              child: Text(state.message.toString()),
            );
          } else {
            return Center(
              child: Text(AppStrings.genericSomethingWentWrongTxt.tr),
            );
          }
        },
      ),
    );
  }
}
