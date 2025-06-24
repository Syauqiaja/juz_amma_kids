import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:juz_amma_kids/core/services/resource_loader.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/presentations/features/quran/recitation/cubit/star_cubit.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerseInputModal extends StatefulWidget {
  final int surahIndex;
  const VerseInputModal(this.surahIndex, {super.key});

  @override
  _VerseInputModalState createState() => _VerseInputModalState();
}

class _VerseInputModalState extends State<VerseInputModal> with SingleTickerProviderStateMixin {
  late StarCubit _starCubit;
  late AnimationController controller;
  FlutterSoundPlayer? _audioPlayerEffect = FlutterSoundPlayer();

  String convertToArabicNumbers(String input) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return input.replaceAllMapped(RegExp(r'[0-9]'), (Match match) {
      return arabicDigits[int.parse(match.group(0)!)];
    });
  }

  @override
  void initState() {
    _starCubit = BlocProvider.of<StarCubit>(context);
    _starCubit.load(widget.surahIndex);
    initAudio();
    super.initState();
  }

  @override
  void dispose() {
    disposeAudio();
    super.dispose();
  }

  initAudio() async {
    _audioPlayerEffect = await FlutterSoundPlayer().openPlayer();
  }

  disposeAudio() async {
    await _audioPlayerEffect!.closePlayer();
  }

  void _showAnimation(int selectedVerse) async {
    await _audioPlayerEffect?.startPlayer(fromDataBuffer: await ResourceLoader.getFromAsset('assets/voice/success.wav'));
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedVerse > 3)
                Lottie.asset(
                  'assets/animations/star_animation.json',
                  repeat: false,
                ),
              if (selectedVerse > 5)
                Lottie.asset(
                  'assets/animations/star_animation.json',
                  repeat: false,
                ),
              Lottie.asset(
                'assets/animations/star_animation.json',
                repeat: false,
                onLoaded: (composition) {
                  controller = AnimationController(
                    vsync: this,
                    duration: composition.duration,
                  );

                  controller.forward();

                  controller.addStatusListener((status) {
                    if (status == AnimationStatus.completed) {
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  final AppLocalizations localization = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Colors.transparent,
      title: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.frameHafalan),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(1.0),
                offset: Offset(1, 0),
                blurRadius: 0,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50.0,
              vertical: 10,
            ),
            child: Text(
              localization.progress_save,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      content: SizedBox(
        height: 500,
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.bgStar),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    BlocBuilder<StarCubit, StarState>(
                      buildWhen: (previous, current) {
                        return current is StarChanged;
                      },
                      builder: (context, state) {
                        return Text(
                          convertToArabicNumbers('${state.star.toInt()}'),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      localization.number_of_verses,
                      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 20,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 18),
                  tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 0),
                  activeTickMarkColor: QuranicTheme.activeTickMarkColor,
                  inactiveTickMarkColor: Colors.grey,
                  trackShape: RoundedRectSliderTrackShape(),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 22),
                  overlayColor: Colors.white,
                  rangeTrackShape: RectangularRangeSliderTrackShape(), // Always show value indicator
                  showValueIndicator: ShowValueIndicator.always,

                  // Customize value indicator shape and style
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(), // More similar to the style in your image
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // You can adjust the font size here
                  ),
                ),
                child: BlocBuilder<StarCubit, StarState>(
                  builder: (context, state) {
                    return Slider(
                      value: state.star.toDouble(),
                      min: 0,
                      max: _starCubit.maxStar.toDouble(),
                      divisions: _starCubit.maxStar,
                      onChanged: (double value) {
                        _starCubit.change(value.round());
                      },
                      onChangeEnd: (value) {
                        _starCubit.save(value.round());
                        Navigator.of(context).pop();
                        if (state.star > 0) {
                          _showAnimation(state.star);
                        }
                      },
                      overlayColor: WidgetStatePropertyAll(Colors.white),
                      activeColor: QuranicTheme.activeColor,
                      thumbColor: QuranicTheme.thumbColor,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
