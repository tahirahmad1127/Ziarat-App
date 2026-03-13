import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/presentation/views/bottom_bar/bottom_bar.dart';
import 'package:ziarat_app/presentation/views/home/home.dart';
import 'package:ziarat_app/presentation/views/language/language.dart';
import 'package:ziarat_app/presentation/views/privacy_policy/privacy_policy.dart';
import 'package:ziarat_app/presentation/views/settings/settings.dart';
import 'package:ziarat_app/presentation/views/sim/network_provider.dart';
import 'package:ziarat_app/presentation/views/sim/package_details.dart';
import 'package:ziarat_app/presentation/views/tasbih_counter/tasbih_counter.dart';
import 'package:ziarat_app/presentation/views/term_conditions/term_conditions.dart';
import 'package:ziarat_app/presentation/views/umrah_guide/umrah_guide.dart';
import 'package:ziarat_app/presentation/views/ziarat/ziarat.dart';

import '../../../infrastructure/models/sim_provider.dart';
import '../faqs_screen/FAQ_Screen.dart';
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomBarScreen()));
          }, child: Text(AppStrings.bottomBarTxt.tr)),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
          }, child: Text(AppStrings.homeScreenTxt.tr)),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Language()));
          }, child: Text(AppStrings.languageScreenTxt.tr)),
          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ZiaratViewBody()),
            );          }, child: Text(AppStrings.ziyaratScreenTxt.tr)),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SimProviderViewBody()));
          }, child: Text(AppStrings.networkProviderScreenTxt.tr)),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => PackageDetailsViewBody(
              provider: SimProviderModel(
                id: '699b98021896e481da555605', // ✅ this one has packages
                title: 'Zong',
              ),
            )));
          }, child: Text(AppStrings.packageDetailsScreenTxt.tr)),        ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> TasbihCounter()));
          }, child: Text(AppStrings.tasbihCounterScreenTxt.tr)),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> UmrahGuide()));
          }, child: Text(AppStrings.umrahGuideScreenTxt.tr)),
          ElevatedButton(onPressed: (){
// ✅ New
            Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyViewBody()));          }, child: Text(AppStrings.privacyPolicyScreenTxt.tr)),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> TermsConditionsViewBody()));
          }, child: Text(AppStrings.termsAndConditionsScreenTxt.tr)),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsPage()));
          }, child: Text(AppStrings.settingsTitleTxt.tr)),
          // In Extra screen
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FaqScreen()));
          }, child: Text(AppStrings.faqScreenTxt.tr)),

          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HaramGatesScreen()));
          }, child: Text(AppStrings.haramGatesScreenTxt.tr)),
        ],),),
    );
  }
}
