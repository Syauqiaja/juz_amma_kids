import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/services/sora_names_const.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:juz_amma_kids/utils/utilities.dart';

class SurahButton extends StatefulWidget {
  final double size;
  final SurahButtonState buttonState;
  final Surah lesson;
  final Function onTap;
  final int type;
  final Color textColor;

  const SurahButton(
      {super.key,
      required this.size,
      required this.buttonState,
      required this.lesson,
      required this.onTap,
      required this.type,
      required this.textColor});

  @override
  State<SurahButton> createState() => _SurahButtonState();
}

class _SurahButtonState extends State<SurahButton> {
  late AppLocalizations _localization;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        audioPlayerEffect?.playButton();
        HapticFeedback.selectionClick();
        setState(() {
          isPressed = true;
        });
        widget.onTap();
      },
      child: AnimatedScale(
        scale: isPressed ? 0.95 : 1.0,
        duration: Duration(milliseconds: 100),
        onEnd: () {
          setState(() {
            isPressed = false;
          });
        },
        curve: Curves.easeInBack,
        child: Container(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Image.asset("assets/images/btn_sora_${widget.type}.png"),
              Align(
                alignment: Alignment.center, // Position the text in the center
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 12),
                  child: FittedBox(
                    fit: BoxFit.contain, // Ensures the text scales down if it overflows
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          SoraNamesConstant.cSoraNames[widget.lesson.soraIndex - 1].replaceAll("سورة ", ""),
                          style: TextStyle(fontWeight: FontWeight.w600, color: widget.textColor),
                        ),
                        Text(
                          "${convertToArabicNumbers(widget.lesson.startAya, locale: _localization.code)} - ${convertToArabicNumbers(widget.lesson.endAya, locale: _localization.code)}",
                          style: TextStyle(color: widget.textColor, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SurahButtonState {
  disabled("disabled.png"),
  star0("star0.png"),
  star1("star1.png"),
  star2("star2.png"),
  star3("star3.png");

  final String assetSuffix;

  const SurahButtonState(this.assetSuffix);
}
