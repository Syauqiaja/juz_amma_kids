import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/core/services/sora_names_const.dart';
import 'package:juz_amma_kids/presentations/modals/surah_button.dart';
import 'package:juz_amma_kids/route/app_routes.dart';
import 'package:juz_amma_kids/utils/list_ext.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SoraSection extends StatefulWidget {
  final int section;
  final double bottomPadding;
  final List<Surah> lessons;
  const SoraSection({super.key, required this.section, required this.bottomPadding, required this.lessons});

  @override
  State<SoraSection> createState() => _SoraSectionState();
}

class _SoraSectionState extends State<SoraSection> {
  late AppLocalizations _localization;
  final GlobalKey _widgetKey = GlobalKey();
  double? widgetWidth;
  double? widgetHeight;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _getWidgetSize());
    refreshPageAfterDelay();
  }

  void refreshPageAfterDelay() {
    Future.delayed(Duration(milliseconds: 200), () {
      if (widgetWidth != 0) {
        setState(() {
          // Rebuild the widget tree
        });
      }
    });
  }

  Future<double> _getWidgetSize() async {
    if(widgetWidth != null){
      return widgetWidth!;
    }

    final renderBox = _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    setState(() {
      widgetWidth = renderBox?.size.width;
      widgetHeight = renderBox?.size.height;
    });
    return widgetWidth!;
  }

  @override
  Widget build(BuildContext context) {
    final gridPadding = MediaQuery.of(context).size.width * 0.072;
    _localization = AppLocalizations.of(context)!;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Column(
          children: [
            Image.asset("assets/images/section_${widget.section}.png"),
          ],
        ),
        widget.lessons.isNotEmpty
            ? FutureBuilder(
                future: _getWidgetSize(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(_localization.error_loading_surah_words));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    context.loaderOverlay.show();
                    return SizedBox();
                  } else {
                    context.loaderOverlay.hide();
                  }

                  final width = snapshot.data!;
                  final height = widgetHeight ?? 0;
                  print("MediaQuery width = $width");
                  print("MediaQuery height = $height");
                  final gridSize = width / 5;
                  final buttonSize = gridSize * 1.232945091514143;

                  final double xHorizontalPad = width * 0.0990016638935108;
                  final double xBotPad = height * 0.021729490022173;
                  print("Horizontal pad = $xHorizontalPad");
                  print("Vertical pad = $xBotPad");

                  return Positioned.fill(
                      child: Stack(
                    children: SoraNamesConstant.buttonCoordinates[widget.section]!
                        .mapIndexed((index, e) => Positioned(
                              left: gridSize * (e['x']! - 1) - 2 + gridPadding,
                              bottom: gridPadding + widget.bottomPadding + gridSize * (e["y"]! - 1),
                              child: SurahButton(
                                size: buttonSize * 0.95,
                                buttonState: SurahButtonState.star0,
                                lesson: index < widget.lessons.length ? widget.lessons[index] : widget.lessons[0],
                                onTap: () async {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.quran,
                                    arguments: index < widget.lessons.length ? widget.lessons[index] : widget.lessons[0],
                                  )
                                      .then((_) async {
                                    SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.portraitDown,
                                      DeviceOrientation.portraitUp,
                                    ]).then((_){
                                      setState(() {});
                                    });
                                  });
                                },
                                type: e["type"]!,
                                textColor: Color(e['color']!),
                              ),
                            ))
                        .toList(),
                  ));
                },
              )
            : Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(),
                ),
              ),
        Positioned.fill(
          left: gridPadding + 4,
          right: gridPadding,
          bottom: gridPadding + 4 + widget.bottomPadding,
          child: Container(
            key: _widgetKey,
            // child: FutureBuilder(
            //     future: _getWidgetSize(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Center(child: Text(_localization.error_loading_surah_words));
            //       }

            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         context.loaderOverlay.show();
            //         return SizedBox();
            //       } else {
            //         context.loaderOverlay.hide();
            //       }

            //       final width = snapshot.data!;
            //       final height = widgetHeight ?? 0;
            //       print("MediaQuery width = $width");
            //       print("MediaQuery height = $height");
            //       final gridSize = width / 5;
            //       final buttonSize = gridSize * 1.232945091514143;

            //       final double xHorizontalPad = width * 0.0990016638935108;
            //       final double xBotPad = height * 0.021729490022173;
            //       print("Horizontal pad = $xHorizontalPad");
            //       print("Vertical pad = $xBotPad");

            //       return CustomPaint(
            //         size: Size.infinite,
            //         painter: AxisPainter(gridSize, color: Colors.red),
            //       );
            //     }),
          ),
        ),
      ],
    );
  }
}
