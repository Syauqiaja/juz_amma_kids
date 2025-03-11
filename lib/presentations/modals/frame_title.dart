import 'package:flutter/material.dart';
import 'package:juz_amma_kids/locator/assets.dart';

class FrameTitle extends StatelessWidget {
  final double? height;
  final double? width;
  final String? asset;
  final Rect? centerSlice;
  final Widget child;
  const FrameTitle({super.key, this.height = 60, this.width = 200, required this.child, this.asset, this.centerSlice});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(asset ?? Assets.btnNew),
            fit: BoxFit.fill,
          ),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(offset: Offset(0, 2), blurRadius: 2, spreadRadius: 0, color: Colors.black.withOpacity(0.3))]),
      child: child,
    );
  }
}
