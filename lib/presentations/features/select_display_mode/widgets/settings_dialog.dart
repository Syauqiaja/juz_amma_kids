import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juz_amma_kids/core/model/language_entity.dart';
import 'package:juz_amma_kids/presentations/features/menu/bloc/localization_bloc.dart';
import 'package:juz_amma_kids/presentations/modals/button_scalable.dart';
import 'package:juz_amma_kids/presentations/modals/frame_panel.dart';
import 'package:juz_amma_kids/presentations/modals/frame_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late AppLocalizations _localization;
  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: FramePanel(
                width: MediaQuery.of(context).size.width * 0.4,
                padding:
                    EdgeInsets.only(top: 64, left: 16, bottom: 16, right: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ButtonScalable(
                      width: double.infinity,
                      child: Text("Bahasa Indonesia",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none)),
                      onTap: () {
                        BlocProvider.of<LocalizationBloc>(context)
                            .add(SaveLocalization(language: Languages.indonesia));
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonScalable(
                      width: double.infinity,
                      child: Text("English",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none)),
                      onTap: () {
                        BlocProvider.of<LocalizationBloc>(context)
                            .add(SaveLocalization(language: Languages.english));
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonScalable(
                      width: double.infinity,
                      child: Text("العربية",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none)),
                      onTap: () {
                        BlocProvider.of<LocalizationBloc>(context)
                            .add(SaveLocalization(language: Languages.arabic));
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
            FrameTitle(
              child: Text(
                _localization.settings,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: '',
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
