import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juz_amma_kids/locator/assets.dart';

class NormalButton extends StatefulWidget {
  final double height;
  final double width;
  final Function onTap;
  final String? imageAsset;
  final Widget? child;
  final EdgeInsets padding;
  final String frameAsset;
  final String frameClickedAsset;
  final bool isEnabled;

  const NormalButton({
    super.key,
    this.height = 48,
    this.width = 48,
    this.frameAsset = "",
    this.frameClickedAsset = "",
    required this.onTap,
    required this.imageAsset,
    this.padding = const EdgeInsets.all(13),
    this.child,
    this.isEnabled = true,
  });

  @override
  State<NormalButton> createState() => _NormalButtonState();
}

class _NormalButtonState extends State<NormalButton> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        HapticFeedback.selectionClick();
        setState(() {
          _isClicked = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isClicked = false;
        });
        if(widget.isEnabled){
          widget.onTap();
        }
      },
      onTapCancel: () {
        setState(() {
          _isClicked = false;
        });
      },
      child: Stack(
        children: [
          Image.asset(
            _isClicked || !widget.isEnabled
                ? (widget.frameClickedAsset == ""
                    ? Assets.btnClicked
                    : widget.frameClickedAsset)
                : (widget.frameAsset == ""
                    ? Assets.btnNormal
                    : widget.frameAsset),
            height: widget.height,
            width: widget.width,
          ),
          if (widget.imageAsset != null)
            Positioned.fill(
              child: Padding(
                padding: widget.padding,
                child: Image.asset(
                  widget.imageAsset!,
                ),
              ),
            ),
          if (widget.child != null)
            Positioned.fill(
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
        ],
      ),
    );
  }
}
