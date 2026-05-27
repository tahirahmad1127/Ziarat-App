import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/views/bottom_bar/bottom_bar.dart';
import 'package:ziarat_app/presentation/views/home/home.dart';
import 'package:ziarat_app/presentation/views/language/language.dart';
import 'package:ziarat_app/presentation/views/privacy_policy/privacy_policy.dart';
import 'package:ziarat_app/presentation/views/settings/settings.dart';
import 'package:ziarat_app/presentation/views/sim/network_provider.dart';
import 'package:ziarat_app/presentation/views/tasbih_counter/tasbih_counter.dart';
import 'package:ziarat_app/presentation/views/term_conditions/term_conditions.dart';
import 'package:ziarat_app/presentation/views/umrah_guide/guide.dart';
import 'package:ziarat_app/presentation/views/ziarat/ziarat.dart';

import '../../../application/sim_provider_bloc/sim_provider_bloc.dart';
import '../../../infrastructure/models/sim_provider.dart';
import '../../../injection_container.dart';
import '../faqs_screen/umrah_faq_screen.dart';
import '../haram_gates/Haram_Gates.dart';
import '../privacy_policy/layout/body.dart';
import '../sim/layout/body.dart';
import '../sim/layout/package_details_body.dart';
import '../term_conditions/layout/body.dart';
import '../ziarat/layout/body.dart';
import '../../constants/app_strings.dart';

class Extra extends StatefulWidget {
  const Extra({super.key});

  @override
  State<Extra> createState() => _ExtraState();
}

class _ExtraState extends State<Extra> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.extraScreenTitleTxt.tr),
        centerTitle: true,
      ),
      body: Center(child:
      Column(children: [
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const BottomBarScreen()));
        }, child: Text(AppStrings.bottomBarTxt.tr)),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home()));
        }, child: Text(AppStrings.homeScreenTxt.tr)),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Language()));
        }, child: Text(AppStrings.languageScreenTxt.tr)),
        ElevatedButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ZiaratViewBody()),
          );
        }, child: Text(AppStrings.ziyaratScreenTxt.tr)),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SimProviderViewBody()));
        }, child: Text(AppStrings.networkProviderScreenTxt.tr)),

        // ✅ Fixed: Package Details - needs bloc so we create it here
        ElevatedButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => sl<SimProviderBloc>(),
                child: PackageDetailsViewBody(
                  provider: SimProviderModel(
                    id: '699b98021896e481da555605', // ✅ this one has packages
                    title: 'Zong',
                  ),
                ),
              ),
            ),
          );
        }, child: Text(AppStrings.packageDetailsScreenTxt.tr)),

        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const TasbihCounter()));
        }, child: Text(AppStrings.tasbihCounterScreenTxt.tr)),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Guide()));
        }, child: Text(AppStrings.umrahGuideScreenTxt.tr)),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyViewBody()));
        }, child: Text(AppStrings.privacyPolicyScreenTxt.tr)),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const TermsConditionsViewBody()));
        }, child: Text(AppStrings.termsAndConditionsScreenTxt.tr)),
        ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SettingsPage()));
        }, child: Text(AppStrings.settingsTitleTxt.tr)),
        // In Extra screen

        ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HaramGatesScreen()));
        }, child: Text(AppStrings.haramGatesScreenTxt.tr)),
      ],),),
    );
  }
}