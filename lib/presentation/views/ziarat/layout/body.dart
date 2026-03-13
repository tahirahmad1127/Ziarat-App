import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ziarat_app/application/ziarat_bloc/ziarat_bloc.dart';
import 'package:ziarat_app/presentation/views/ziarat/ziarat.dart';
import '../../../../injection_container.dart';

class ZiaratViewBody extends StatelessWidget {
  const ZiaratViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ziaratBloc = sl<ZiaratBloc>()..add(const GetMakkahZiaratEvent());

    return BlocProvider.value(
      value: ziaratBloc,
      child: Ziarat(ziaratBloc: ziaratBloc),
    );
  }
}