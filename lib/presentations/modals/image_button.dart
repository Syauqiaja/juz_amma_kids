import 'package:flutter/material.dart';

class CustomImageButton extends StatefulWidget {
  final Function onTap;
  final String imageAsset;
  final String imageAssetClicked;
  final double height;
  final double width;
  const CustomImageButton({
    super.key,
    required this.onTap,
    required this.imageAsset,
    required this.imageAssetClicked,
    this.height = 32,
    this.width = 32,
  });

  @override
  State<CustomImageButton> createState() => _CustomImageButtonState();
}

class _CustomImageButtonState extends State<CustomImageButton> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        setState(() {
          isClicked = false;
          widget.onTap();
        });
      },
      onTapDown: (details) {
        setState(() {
          isClicked = true;
        });
      },
      onTapCancel: () => setState(() {
        isClicked = false;
      }),
      child: Image.asset(
        isClicked ? widget.imageAssetClicked : widget.imageAsset,
        height: widget.height,
        width: widget.width,
      ),
    );
  }
}
