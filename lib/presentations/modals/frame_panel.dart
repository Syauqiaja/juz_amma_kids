import 'package:flutter/material.dart';
import 'package:juz_amma_kids/locator/assets.dart';

class FramePanel extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget child;
  const FramePanel({super.key, this.height, this.width, this.margin, this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.frameLogin),
          centerSlice: Rect.fromLTWH(
            15, 15, // X and Y offset of the resizable area
            40, 40, // Width and height of the resizable area
          ),
          fit: BoxFit.fill,
        ),
        // color: Colors.red,
      ),
      padding: padding ?? EdgeInsets.all(24),
      margin: margin ?? EdgeInsets.symmetric(horizontal: 24),
      child: child,
    );
  }
}
