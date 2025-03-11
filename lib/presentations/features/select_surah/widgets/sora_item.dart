import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/presentations/modals/button_scalable.dart';

class SoraItem extends StatefulWidget {
  final Surah surah;
  final bool? isSelected;
  final Function onTap;
  const SoraItem({super.key, required this.surah, this.isSelected, required this.onTap});

  @override
  State<SoraItem> createState() => _SoraItemState();
}

class _SoraItemState extends State<SoraItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSlide(
          offset: widget.isSelected == true? Offset(0, 1.9): Offset(0, 1),
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: widget.isSelected == true ? 1 : 0,
            child: Column(
              children: [
                    const SizedBox(height: 8),
                ButtonScalable(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.bookSmall, height: 24, width: 24),
                    const SizedBox(width: 4),
                    Text("Read", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                  ],
                ), onTap: (){
                
                }),
                    const SizedBox(height: 8),
                ButtonScalable(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.starSmall, height: 24, width: 24),
                    const SizedBox(width: 4),
                    Text("Practice", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                  ],
                ), onTap: (){
                
                }),
              ],
            ),
          ),
        ),
        AnimatedSlide(
          offset: widget.isSelected == true? Offset(0, -0.5) : Offset(0, -0.2),
          duration: Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
          child: GestureDetector(
            onTap: (){
              widget.onTap();
            },
            child: Container(
              width: 200,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:Color(0XFFF7FAFE),
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    color: Color(0XFF94CAD0),
                    ),
                    child: SvgPicture.asset(widget.surah.imageAsset, fit: BoxFit.fitHeight, color: Colors.white,),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.surah.title, style: TextStyle(fontSize: 14, color: Color(0xFF77759A)),),
                  const SizedBox(height: 4),
                  Text("${widget.surah.totalAya} Ayah", style: TextStyle(fontSize: 14, color: Color(0xFF77759A)),),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.withAlpha(100))
                    ),
                    padding: EdgeInsets.all(4),
                    child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Assets.starSmall),
                            const SizedBox(width: 4),
                            Text('50%')
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Assets.bookSmall),
                            const SizedBox(width: 4),
                            Text('25%')
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}