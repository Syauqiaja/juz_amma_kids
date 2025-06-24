import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/presentations/modals/button_scalable.dart';
import 'package:juz_amma_kids/route/app_routes.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:juz_amma_kids/utils/context_ext.dart';

class SelectDisplayMode extends StatefulWidget {
  const SelectDisplayMode({super.key});

  @override
  State<SelectDisplayMode> createState() => _SelectDisplayModeState();
}

class _SelectDisplayModeState extends State<SelectDisplayMode>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlayAnimation = false;

  late AppLocalizations _localization;
  bool isLargeScreen = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    isLargeScreen = MediaQuery.of(context).size.height > 650;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: QuranicTheme.scaffoldColor,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      Assets.bgMountain,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 32),
                      Expanded(
                        child: Padding(
                          padding: context.isTablet() ? EdgeInsets.only(top: 40, bottom: 24, left: 72, right: 72) : isLargeScreen
                              ? EdgeInsets.only(
                                  top: 40,
                                  bottom: 24,
                                )
                              : EdgeInsets.all(0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textDirection: TextDirection.ltr,
                              children: [
                                Image.asset(Assets.title, height: 150,),
                                const SizedBox(height: 48),
                                ButtonScalable(child: Text(_localization.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), onTap: (){
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.selectSurahList);
                                }),
                                const SizedBox(height: 16),
                                // ButtonScalable(child: Text(_localization.settings, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), onTap: (){
                                //     showDialog(context: context, builder: (ctx){
                                //       return SettingsDialog();
                                //     });
                                // }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
