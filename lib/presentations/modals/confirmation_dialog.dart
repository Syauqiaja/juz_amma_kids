import 'package:flutter/material.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:juz_amma_kids/presentations/modals/button_scalable.dart';
import 'package:juz_amma_kids/presentations/modals/frame_panel.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmationDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onConfirm;

  const ConfirmationDialog({super.key, required this.title, required this.subtitle, required this.onConfirm});

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  late AppLocalizations _localization;

  @override
  void initState() {
    audioPlayerEffect?.playOpenPanel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            FramePanel(
              child: Column(
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonScalable(
                          child: Text(_localization.yes, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
                          onTap: () {
                            audioPlayerEffect?.playButton();
                            widget.onConfirm();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: ButtonScalable(
                          child: Text(_localization.cancel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
                          onTap: () {
                            audioPlayerEffect?.playButton();
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
