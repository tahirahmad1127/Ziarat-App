import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FrontEndConfig{
   static late double screenWidth;
   static late double screenHeight;

   static void init(BuildContext context) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
   }

   // Base design width (your UI designed on this width)
   static double _baseWidth = 375;

   static double responsiveFont(double size) {
      return screenWidth * (size / _baseWidth);
   }
   ///Colors
   static Color backgroundColor = const Color(0xff243243);
   static LinearGradient btnBorderColor = const LinearGradient(colors: [
      Color(0xffA0832C),
      Color(0xffFAD25B),
      Color(0xff9B8030),
   ]);
   static Color btnTextColor = const Color(0xffFFFFFF);
   static Color iconColor = const Color(0xffFFFFFF);
   static Color appBarTitleColor = const Color(0xffFFFFFF);
   static Color textColor = const Color(0xffFFFFFF);
   static LinearGradient tasbihColor = const LinearGradient(colors: [
      Color(0xffC89C18),
      Color(0xffE9C41E),
   ]);

   static Color listTileColor = const Color(0xff354A64);
   static LinearGradient listTileBorder = const LinearGradient(colors: [
      Color(0xffA0832C),
      Color(0xffFAD25B),
      Color(0xff9B8030),
   ]);
   static Color listTileTextColor = const Color(0xffFFFFFF);
   static Color listTileIconColor = const Color(0xffFFFFFF);
   static Color arabicTextColor = const Color(0xffA2A2A2);
   static Color arabicAyatTextColor = const Color(0xffFFFFFF);
   static Color subHeadingTextColor = const Color(0xffC1C1C1);









   ///Button Text Style
   static TextStyle btnTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: btnTextColor,
      fontFamily: GoogleFonts.raleway().fontFamily,
   );
   ///Body Text Style
   static TextStyle bodyTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textColor,
      fontFamily: GoogleFonts.raleway().fontFamily,
   );
   ///Sub Heading Text Style
   static TextStyle subHeadingTextStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: subHeadingTextColor,
      fontFamily: GoogleFonts.raleway().fontFamily,
   );
   ///Heading Text Style
   static TextStyle headingTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: textColor,
      fontFamily: GoogleFonts.raleway().fontFamily,
   );
   ///Arabic Text Style
   static TextStyle arabicTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: arabicTextColor,
      fontFamily: GoogleFonts.amiriQuran().fontFamily,
   );
   ///Arabic Text Style
   static TextStyle arabicAyatTextStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: arabicAyatTextColor,
      fontFamily: GoogleFonts.amiriQuran().fontFamily,
   );

   ///Main Text Style
   static TextStyle mainTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textColor,
      fontFamily: GoogleFonts.raleway().fontFamily,
   );

   ///Language Heading Style
   static TextStyle languageHeadingTextStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: textColor,
      fontFamily: GoogleFonts.raleway().fontFamily,
   );
   ///TabBar Text Style
   static TextStyle tabBarTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: textColor,
      fontFamily: GoogleFonts.raleway().fontFamily,
   );
   ///Package Details Text Style
   static TextStyle packageDetailTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 9,
      color: textColor,
      fontFamily: GoogleFonts.inter().fontFamily,
   );
   ///Package Details Text Style
   static TextStyle packageTextStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: textColor,
      fontFamily: GoogleFonts.raleway().fontFamily,

   );



}