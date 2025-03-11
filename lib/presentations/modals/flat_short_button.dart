import 'package:flutter/material.dart';
import 'package:juz_amma_kids/locator/assets.dart';

class FlatShortButton extends StatefulWidget {
  final Function onTap;
  final Widget child;
  const FlatShortButton({super.key, required this.onTap, required this.child});

  @override
  State<FlatShortButton> createState() => _FlatShortButtonState();
}

class _FlatShortButtonState extends State<FlatShortButton> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details){
        setState(() {
          isClicked = true;
        });
        widget.onTap();
      },
      onTapUp: (details) {
        setState(() {
          isClicked = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isClicked = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            Assets.buttonNoShadow,
            color: isClicked? Colors.white.withOpacity(0.9) : Colors.white,
            colorBlendMode: BlendMode.modulate,
          ),
          widget.child,
        ],
      ),
    );
  }
}
