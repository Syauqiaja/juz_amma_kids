import 'package:flutter/material.dart';
import 'package:juz_amma_kids/locator/assets.dart';

class FrameButton extends StatefulWidget {
  final double height;
  final double width;
  final Function onTap;
  final Widget child;
  final String frameAsset;
  final String frameAssetClicked;
  final EdgeInsets padding;

  const FrameButton({
    super.key,
    this.height = 48,
    this.width = 126,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.all(8),
    this.frameAsset = Assets.btnFrameOrange,
    this.frameAssetClicked = Assets.btnFrameOrangeClicked,
  });

  @override
  State<FrameButton> createState() => _FrameButtonState();
}

class _FrameButtonState extends State<FrameButton> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isClicked = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isClicked = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isClicked = false;
        });
      },
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              _isClicked ? widget.frameAssetClicked : widget.frameAsset,
              height: widget.height,
              width: widget.width,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            child: Padding(
              padding: widget.padding,
              child: Center(
                child: widget.child,
              )
            ),
          ),
        ],
      ),
    );
  }
}
