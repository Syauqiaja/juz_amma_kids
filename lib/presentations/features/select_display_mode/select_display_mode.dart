import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/presentations/features/select_display_mode/widgets/hole_painter.dart';
import 'package:juz_amma_kids/presentations/modals/button_scalable.dart';
import 'package:juz_amma_kids/presentations/modals/frame_panel.dart';
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
  Size _size = Size.zero;
  late AnimationController _animationController;
  late Animation<double> _splashAnimation =
      Tween<double>(begin: 0, end: 10).animate(_animationController);

  late AppLocalizations _localization;
  bool isLargeScreen = false;
  bool isPlayAnimation = false;

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
    _size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    isLargeScreen = MediaQuery.of(context).size.height > 650;
    print("Is larege screen : $isLargeScreen");
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
                      Image.asset(Assets.title, height: 72,),
                                const SizedBox(height: 64),
                                ButtonScalable(child: Text(_localization.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), onTap: (){
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.selectSurahList);
                                }),
                                const SizedBox(height: 16),
                                ButtonScalable(child: Text(_localization.settings, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), onTap: (){
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.selectSurahList);
                                }),
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
          if (isPlayAnimation)
            Container(
              height: double.infinity,
              width: double.infinity,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: HolePainter(
                          color: Colors.black,
                          holeSize: _splashAnimation.value * _size.width),
                    );
                  }),
            ),
        ],
      ),
    );
  }
}
