import 'package:flutter/material.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/views/home/home.dart';

import '../../constants/asset_constant.dart';
import '../settings/settings.dart';
import '../tasbih_counter/tasbih_counter.dart';
import '../umrah_guide/umrah_guide.dart';
import '../ziarat/layout/body.dart';
import '../ziarat/ziarat.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int selectedIndex = 0;

  final List<Map<String, String>> navItems = [
    {
      'selected': AssetConstant.kHomeSelected,
      'unselected': AssetConstant.kHomeUnselected,
    },
    {
      'selected': AssetConstant.kZiaratSelected,
      'unselected': AssetConstant.kZiaratUnselected,
    },
    {
      'selected': AssetConstant.kTasbihSelected,
      'unselected': AssetConstant.kTasbihUnselected,
    },
    {
      'selected': AssetConstant.kUmrahSelected,
      'unselected': AssetConstant.kUmrahUnselected,
    },
    {
      'selected': AssetConstant.kSettingSelected,
      'unselected': AssetConstant.kSettingUnselected,
    },
  ];

  final List<Widget> screens = const [
    Home(),
    ZiaratViewBody(),
    TasbihCounter(),
    UmrahGuide(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 5),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: FrontEndConfig.btnBorderColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: FrontEndConfig.listTileColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      navItems.length,
                          (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: SizedBox(
                          width: 45,
                          height: 58,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// Top indicator — flush to top
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                height: 3,
                                width: selectedIndex == index ? 15 : 0,
                                decoration: BoxDecoration(
                                  gradient: selectedIndex == index
                                      ? FrontEndConfig.btnBorderColor
                                      : null,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(2),
                                    bottomRight: Radius.circular(2),
                                  ),
                                ),
                              ),

                              /// Icon centered in remaining space
                              Expanded(
                                child: Center(
                                  child: _buildNavIcon(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(int index) {
    final isSelected = selectedIndex == index;
    final isHome = index == 0;

    // Home unselected → black tint; others use their own unselected asset
    if (!isSelected && isHome) {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        child: Image.asset(
          navItems[index]['unselected']!,
          width: 24,
          height: 24,
        ),
      );
    }

    // Selected → apply gradient shader mask
    if (isSelected) {
      return ShaderMask(
        shaderCallback: (bounds) => FrontEndConfig.btnBorderColor.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        blendMode: BlendMode.srcIn,
        child: Image.asset(
          navItems[index]['selected']!,
          width: 24,
          height: 24,
        ),
      );
    }

    // Unselected (non-home) → use unselected asset as-is
    return Image.asset(
      navItems[index]['unselected']!,
      width: 24,
      height: 24,
    );
  }
}