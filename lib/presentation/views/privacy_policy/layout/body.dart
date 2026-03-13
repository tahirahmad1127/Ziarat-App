import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/application/privacy_policy_bloc/privacy_policy_bloc.dart';
import 'package:ziarat_app/presentation/views/privacy_policy/privacy_policy.dart';
import '../../../../injection_container.dart';
import '../../../processing_widget.dart';
import '../../../constants/app_strings.dart';

class PrivacyPolicyViewBody extends StatelessWidget {
  const PrivacyPolicyViewBody({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => sl<PrivacyPolicyBloc>(),
      child: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
        builder: (context, state) {
          if (state is PrivacyPolicyInitial) {
            BlocProvider.of<PrivacyPolicyBloc>(context).add(const GetPrivacyPolicyEvent());
            return const Center(
              child: ProcessingWidget(),
            );
          } else if (state is PrivacyPolicyLoading) {
            return const Center(
              child: ProcessingWidget(),
            );
          } else if (state is PrivacyPolicyLoaded) {
            return PrivacyPolicy(
              privacyPolicy: state.model,
            );
          } else if (state is PrivacyPolicyFailed) {
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