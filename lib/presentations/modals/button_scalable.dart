import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:juz_amma_kids/utils/context_ext.dart';

class ButtonScalable extends StatefulWidget {
  final double? height;
  final double? width;
  final String? asset;
  final Color? borderColor;
  final Widget child;
  final VoidCallback onTap;
  const ButtonScalable(
      {super.key,
      this.height = 45,
      this.width = 200,
      required this.child,
      required this.onTap,
      this.asset,
      this.borderColor});

  @override
  State<ButtonScalable> createState() => _ButtonScalableState();
}

class _ButtonScalableState extends State<ButtonScalable> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        audioPlayerEffect?.playButton();
        HapticFeedback.selectionClick();
        setState(() {
          isClicked = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isClicked = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          isClicked = false;
        });
      },
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 100), // Animation duration
        tween: Tween<double>(begin: 1.0, end: isClicked ? 0.7 : 1.0),
        builder: (context, opacity, child) {
          return Opacity(
            opacity: opacity,
            child: Container(
              height: widget.height,
              width: widget.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.asset ?? Assets.btnNew),
                  // centerSlice: Rect.fromLTWH(
                  //   30, 15, 90, 109, // Adjust these values to fit your image better
                  // ),

                  fit: BoxFit.fill,
                ),
                border: Border.all(
                    color: widget.borderColor ?? QuranicTheme.buttonBorderColor,
                    width: 2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: context.isTablet() ? 18 : 16),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}
