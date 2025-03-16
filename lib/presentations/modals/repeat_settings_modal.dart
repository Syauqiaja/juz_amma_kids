import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:juz_amma_kids/presentations/modals/frame_button.dart';
import 'package:juz_amma_kids/presentations/modals/frame_title.dart';
import 'package:juz_amma_kids/presentations/modals/normal_button.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:juz_amma_kids/utils/list_ext.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:juz_amma_kids/utils/utilities.dart';

class RepeatSettingsModal extends StatefulWidget {
  final Function(int repeatCount, int startAyah, int endAyah) onSave;
  final int maxAya;

  const RepeatSettingsModal(
      {Key? key, required this.onSave, required this.maxAya})
      : super(key: key);

  @override
  _RepeatSettingsModalState createState() => _RepeatSettingsModalState();
}

FlutterSoundPlayer? _audioPlayerEffect = FlutterSoundPlayer();

class _RepeatSettingsModalState extends State<RepeatSettingsModal> {
  int repeatCount = 1; // Default repetition count
  int startAyah = 1; // Default start ayah
  int endAyah = 2; // Default end ayah
  int selectedRepeatCount = 1; // Default selected repeat count

  initAudio() async {
    _audioPlayerEffect = await FlutterSoundPlayer().openPlayer();
  }

  disposeAudio() async {
    await _audioPlayerEffect!.closePlayer();
  }

  @override
  void initState() {
    initAudio();
    endAyah = widget.maxAya;
    super.initState();
  }

  @override
  void dispose() {
    disposeAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localization = AppLocalizations.of(context)!;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent, // Background color to match style
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.symmetric(horizontal: 120),
      titlePadding: EdgeInsets.all(0),
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Stack(
              children: [
                Positioned.fill(
                  right: 20,
                  left: 20,
                  child: Image.asset(
                    Assets.bgDialog,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 32, left: 40, right: 40, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pemilihan Ayat (dari - sampai)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                Assets.btnDropdownLong,
                                width: 190,
                                height: 40,
                                fit: BoxFit.fill,
                              ),
                              Positioned.fill(
                                top: -3,
                                right: 0,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 15, left: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        localization.from,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      Flexible(
                                        child: DropdownButtonFormField<int>(
                                          padding: EdgeInsets.all(0),
                                          alignment: Alignment.centerRight,
                                          menuMaxHeight: 200,
                                          dropdownColor:
                                              QuranicTheme.primaryColor,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            isDense: true,
                                            border: InputBorder.none,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Image.asset(
                                                Assets.icDropdown,
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                          ),
                                          icon: Container(),
                                          value: startAyah,
                                          items: List.generate(
                                            widget.maxAya +
                                                1, // Sesuaikan jumlah ayat dengan Surah An-Naas
                                            (index) => DropdownMenuItem(
                                              value: index,
                                              child: Center(
                                                child: Text(
                                                  convertToArabicNumbers(index,
                                                      locale:
                                                          localization.code),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onChanged: (int? newValue) {
                                            setState(() {
                                              startAyah = newValue!;
                                              if (startAyah > endAyah) {
                                                // Ensure start ayah is never greater than end ayah
                                                endAyah = startAyah;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Image.asset(
                                Assets.btnDropdown,
                                width: 130,
                                height: 40,
                                fit: BoxFit.fill,
                              ),
                              Positioned.fill(
                                top: -3,
                                right: 0,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 15, left: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        localization.to,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      Flexible(
                                        child: DropdownButtonFormField<int>(
                                          padding: EdgeInsets.all(0),
                                          alignment: Alignment.centerRight,
                                          menuMaxHeight: 200,
                                          dropdownColor:
                                              QuranicTheme.primaryColor,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            isDense: true,
                                            border: InputBorder.none,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Image.asset(
                                                Assets.icDropdown,
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                          ),
                                          icon: Container(),
                                          value: endAyah,
                                          items: startAyah
                                              .to(widget.maxAya)
                                              .map(
                                                (index) => DropdownMenuItem(
                                                  value: index,
                                                  child: Center(
                                                    child: Text(
                                                      convertToArabicNumbers(
                                                          index,
                                                          locale: localization
                                                              .code),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (int? newValue) {
                                            setState(() {
                                              endAyah = newValue!;
                                              if (endAyah < startAyah) {
                                                // Ensure end ayah is never less than start ayah
                                                startAyah = endAyah;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Pilihan untuk jumlah perulangan menggunakan tombol
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildAyahButton(1),
                          buildAyahButton(2),
                          buildAyahButton(3),
                          buildAyahButton(4),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 20,
            right: 20,
            child: Center(
              child: FrameTitle(
                height: null,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    localization.repeatSettings,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: NormalButton(
              onTap: () async {
                audioPlayerEffect?.playButton();
                HapticFeedback.selectionClick();
                Navigator.of(context).pop();
              },
              imageAsset: Assets.icClose,
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: FrameButton(
            onTap: () {
              widget.onSave(selectedRepeatCount, startAyah,
                  endAyah); // Kirim hasil ke fungsi onSave
              HapticFeedback.selectionClick();
              Navigator.pop(context);
            },
            child: Text(localization.confirm,
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // Build Ayah Button (untuk jumlah perulangan)
  Widget buildAyahButton(int number) {
    localization = AppLocalizations.of(context)!;
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedRepeatCount =
                  number; // Mengatur jumlah perulangan berdasarkan tombol yang dipilih
            });
          },
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 24),
            child: Stack(
              children: [
                Image.asset(
                  Assets.miniFrameBlue,
                  fit: BoxFit.fill,
                  height: 60,
                  width: 60,
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      convertToArabicNumbers(
                          number == 4
                              ? max(number, selectedRepeatCount)
                              : number,
                          locale: localization.code),
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (number >= 4)
          Positioned(
            right: localization.code == 'ar' ? null : 0,
            left: localization.code == 'ar' ? 0 : null,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                height: 24,
                width: 24,
                child: NormalButton(
                  onTap: () {
                    if (selectedRepeatCount < 4) {
                      setState(() {
                        selectedRepeatCount = 4;
                        selectedRepeatCount++;
                      });
                    } else if (selectedRepeatCount <= 10) {
                      setState(() {
                        selectedRepeatCount++;
                      });
                    }
                  },
                  imageAsset: Assets.icPositive,
                  height: 24,
                  width: 24,
                  padding: EdgeInsets.all(8),
                ),
              ),
            ),
          ),
        if (number >= 4)
          Positioned(
            left: localization.code == 'ar' ? null : 0,
            right: localization.code == 'ar' ? 0 : null,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                height: 24,
                width: 24,
                child: NormalButton(
                  onTap: () {
                    setState(() {
                      if (selectedRepeatCount > 4) {
                        selectedRepeatCount--;
                      } else {
                        selectedRepeatCount = 4;
                      }
                    });
                  },
                  imageAsset: Assets.icNegative,
                  height: 24,
                  width: 24,
                  padding: EdgeInsets.all(8),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: number < 4
                ? Container(
                    height: 20,
                    width: 20,
                    child: selectedRepeatCount == number
                        ? Image.asset(
                            Assets.starSelected,
                            height: 20,
                            width: 20,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            Assets.starUnselected,
                            height: 20,
                            width: 20,
                            fit: BoxFit.fill,
                          ),
                  )
                : Container(
                    height: 20,
                    width: 20,
                    child: selectedRepeatCount >= number
                        ? Image.asset(
                            Assets.starSelected,
                            height: 20,
                            width: 20,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            Assets.starUnselected,
                            height: 20,
                            width: 20,
                            fit: BoxFit.fill,
                          ),
                  ),
          ),
        )
      ],
    );
  }
}
