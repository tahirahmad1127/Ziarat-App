import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/application/terms_conditions_bloc/terms_conditions_bloc.dart';
import '../../../../injection_container.dart';
import '../../../processing_widget.dart';
import '../../../constants/app_strings.dart';
import '../term_conditions.dart';

class TermsConditionsViewBody extends StatelessWidget {
  const TermsConditionsViewBody({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => sl<TermsConditionsBloc>(),
      child: BlocBuilder<TermsConditionsBloc, TermsConditionsState>(
        builder: (context, state) {
          if (state is TermsConditionsInitial) {
            BlocProvider.of<TermsConditionsBloc>(context).add(const GetTermsConditionsEvent());
            return const Center(
              child: ProcessingWidget(),
            );
          } else if (state is TermsConditionsLoading) {
            return const Center(
              child: ProcessingWidget(),
            );
          } else if (state is TermsConditionsLoaded) {
            return TermAndConditions(termsConditions: state.model);
          }
          else if (state is TermsConditionsFailed) {
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
