import 'package:flutter/material.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/presentations/modals/image_button.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> items;
  final Function(dynamic) onSelect;
  final dynamic startingValue;
  final VoidCallback? onDropdownOpened; // New parameter

  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.onSelect,
    this.startingValue,
    this.onDropdownOpened, // Add this line
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  GlobalKey dropdownKey = GlobalKey();
  dynamic _currentValue;

  @override
  void initState() {
    _currentValue = widget.startingValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomImageButton(
          onTap: () {
            // Call the audio playback when the dropdown is tapped
            if (widget.onDropdownOpened != null) {
              widget.onDropdownOpened!();
            }

            dropdownKey.currentContext?.visitChildElements((element) {
              if (element.widget is Semantics) {
                element.visitChildElements((element) {
                  if (element.widget is Actions) {
                    element.visitChildElements((element) {
                      Actions.invoke(element, ActivateIntent());
                    });
                  }
                });
              }
            });
          },
          imageAsset: Assets.frameWithPrefix,
          imageAssetClicked: Assets.frameWithPrefixClicked,
          width: 125,
          height: 45,
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                key: dropdownKey,
                alignment: Alignment.center,
                dropdownColor: QuranicTheme.primaryColor,
                icon: Container(),
                items: widget.items,
                value: _currentValue,
                onChanged: (value) {
                  print("Selected value : $value");
                  setState(() {
                    _currentValue = value;
                  });
                  widget.onSelect(value);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
