import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/core/model/surah_word.dart';
import 'package:juz_amma_kids/core/services/database_service.dart';
import 'package:juz_amma_kids/core/services/resource_loader.dart';
import 'package:juz_amma_kids/global/z-global.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:juz_amma_kids/presentations/features/quran/recitation/cubit/read_quran_cubit.dart';
import 'package:juz_amma_kids/presentations/features/quran/widgets/cubit/mushaf_cubit.dart';
import 'package:juz_amma_kids/presentations/features/quran/widgets/mushaf_box.dart';
import 'package:juz_amma_kids/presentations/features/select_display_mode/widgets/hole_painter.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/cubit/select_sora_cubit.dart';
import 'package:juz_amma_kids/presentations/modals/normal_button.dart';
import 'package:juz_amma_kids/presentations/modals/repeat_settings_modal.dart';
import 'package:juz_amma_kids/presentations/modals/verse_input_modal.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:juz_amma_kids/utils/context_ext.dart';
import 'package:juz_amma_kids/utils/utilities.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../bloc/quran_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuranScreen extends StatefulWidget {
  final Surah surah;
  const QuranScreen({super.key, required this.surah});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> with SingleTickerProviderStateMixin{
  late QuranBloc _quranBloc;
  late ReadQuranCubit _readQuranCubit;
  late MushafCubit _mushafCubit;
  late AppLocalizations _localization;
  Size _size = Size.zero;

  late Future<BorderImages> _borderImagesFuture;
  FlutterSoundPlayer? _audioPlayer =
      FlutterSoundPlayer(); // Initialize FlutterSoundPlayer
  FlutterSoundPlayer? _audioPlayerEffect = FlutterSoundPlayer();
  int repeatCountdown = 0;
  ScrollController _scrollController = ScrollController();
  late Future<List<SurahWord>> disabledWords;

  bool dropdownClicked = false;
  GlobalKey dropdownKey = GlobalKey(debugLabel: "dropdown_select_ayah");


  late AnimationController _animationController;
  late Animation<double> _splashAnimation =
      Tween<double>(begin: 0, end: 10).animate(_animationController);
  bool isPlayAnimation = false;

  @override
  void initState() {
    super.initState();
    _quranBloc = BlocProvider.of<QuranBloc>(context);
    _mushafCubit = BlocProvider.of<MushafCubit>(context);
    _readQuranCubit = BlocProvider.of(context);

    

    disabledWords = DatabaseService().getDisabledWords(widget.surah.soraIndex);
    initAudio();

    _readQuranCubit.init();

    _borderImagesFuture = Globals.loadBorderImages(); // Load the borders

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _quranBloc.add(LoadQuran(surahIndex: widget.surah.soraIndex));


    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    precacheImage(AssetImage(Assets.btnFrameOrangeClicked), context);
    precacheImage(AssetImage(Assets.btnClicked), context);
    precacheImage(AssetImage(Assets.icPause), context);
    precacheImage(AssetImage(Assets.icStop), context);
    precacheImage(AssetImage(Assets.frameWithPrefixClicked), context);
    _size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    disposeAudio();
    _animationController.dispose();
    super.dispose();
  }

  initAudio() async {
    _audioPlayer = await FlutterSoundPlayer().openPlayer();
    _audioPlayerEffect = await FlutterSoundPlayer().openPlayer();

    print("Audio finished loading");
  }

  disposeAudio() async {
    _audioPlayer?.stopPlayer();
    _audioPlayer?.closePlayer();

    _audioPlayerEffect?.stopPlayer();
    _audioPlayerEffect?.closePlayer();
  }

  /// Convert Capcut style timelapse, into universal millis
  int _getMillisFromTimelapse(String timelapse) {
    List<String> time = timelapse.split(":");
    int second = int.parse(time[0]);
    int millis = int.parse(time[1]);

    return ((second * 1000) + (millis * 33));
  }

  Future<void> _handleAyahCompletion() async {
    if (!_quranBloc.isRepeating) {
      _readQuranCubit.markAsRead(_quranBloc.selectedAyahIndex);
      _quranBloc
          .add(PlayNext()); // Play the next ayah after the current one finishes
    }
  }

  Future<void> _repeatAyah(int startAyah, int endAyah, int repeatCount) async {
    repeatCountdown = repeatCount; // Set the repeat countdown to repeatCount

    await _playRepeating(startAyah, endAyah, repeatCount - 1, repeatCount - 1);

    repeatCountdown = 0; // Reset repeat countdown
  }

  Future<void> _playRepeating(
      int aya, int endAya, int repeatCount, int maxRepeat) async {
    if (aya <= endAya) {
      _mushafCubit.select(aya);
      await _audioPlayer?.startPlayer(
        fromDataBuffer:
            await ResourceLoader.getRecitation(widget.surah.soraIndex, aya),
        whenFinished: () async {
          _readQuranCubit.markAsRead(aya);
          if (repeatCount == 0) {
            await _playRepeating(aya + 1, endAya, maxRepeat, maxRepeat);
          } else {
            await _playRepeating(aya, endAya, repeatCount - 1, maxRepeat);
          }
        },
      );
    } else {
      _quranBloc.add(StopRepeating());
    }
  }

  Future<void> _handleAyahSelection(int index) async {
    _mushafCubit.select(index);
    _quranBloc.add(PlaySequential(startAya: index));

    _jumpTo(index);
  }

  Future<void> _jumpTo(int ayahIndex) async {
    double totalExtent = _scrollController.position.maxScrollExtent;
    double itemHeight = (totalExtent / (_quranBloc.totalLine + 1));

    double line = _quranBloc.findLineOfAyah(ayahIndex);
    if (line <= 2) {
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
      return;
    }
    line++;
    double target = itemHeight * line;
    _scrollController.animateTo(target,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void _showVerseInputDialog(BuildContext builderContext) {
    showDialog(
      context: builderContext,
      builder: (context) {
        return VerseInputModal(widget.surah.soraIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    final double topMargin = context.isTablet() ? 48 : 24;
    final double botMargin = context.isTablet() ? 48 : 24;
    final double leftMargin = context.isTablet() ? 48 : 24;
    final double rightMargin = context.isTablet() ? 48 : 24;
    final double gap = context.isTablet() ? 24 : 16;
    return Stack(
      children: [
        Positioned.fill(
          child: MultiBlocListener(
            listeners: [
              BlocListener<ReadQuranCubit, ReadQuranState>(
                  listener: (context, state) {
                if (state is ReadQuranWithData) {
                  context.read<SelectSoraCubit>().update(widget.surah.soraIndex);
                }
              }),
              BlocListener<QuranBloc, QuranState>(
                listener: (context, state) async {
                  if (state is QuranPlaying) {
                    if (state.startAya != null) {
                      if (state.endAya != null) {
                        _repeatAyah(
                            state.startAya!, state.endAya!, state.repeatCount!);
                      } else {
                        _mushafCubit.select(state.startAya!);
          
                        if (widget.surah.soraIndex == 1 && state.startAya == 0) {
                          await _handleAyahCompletion();
                        } else {
                          await _audioPlayer?.stopPlayer();
                          await _audioPlayer?.startPlayer(
                              fromDataBuffer: await ResourceLoader.getRecitation(
                                  widget.surah.soraIndex, state.startAya!),
                              whenFinished: () async {
                                await _handleAyahCompletion();
                              });
                        }
                      }
                    } else {
                      await _audioPlayer?.resumePlayer();
                    }
                  } else if (state is QuranPaused) {
                    await _audioPlayer?.pausePlayer();
                  } else if (state is QuranStopped) {
                    await _audioPlayer?.stopPlayer();
                  }
                },
              ),
              BlocListener<MushafCubit, MushafState>(
                listener: (context, state) {
                  if (state.selectedAyahIndex > 0) {
                    _jumpTo(state.selectedAyahIndex);
                  }
                },
              ),
            ],
            child: Scaffold(
              body: Container(
                padding: EdgeInsets.only(
                  top: topMargin,
                  bottom: botMargin,
                  left: leftMargin,
                  right: rightMargin,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.bg), // Background image
                    fit: BoxFit.cover, // Ensure the image covers the whole screen
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                // Book progress bar (read tracking)
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    Assets.circularProgressBook,
                                    width: 64,
                                    height: 64,
                                  ),
                                  BlocBuilder<ReadQuranCubit, ReadQuranState>(
                                    builder: (context, state) {
                                      if (state is ReadQuranWithData) {
                                        return CircularPercentIndicator(
                                          radius: 32,
                                          percent:
                                              min(state.readCount / state.maxRead, 1),
                                          progressColor: QuranicTheme.primaryColor,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.1),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: gap),
                          Expanded(
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 1.7,
                                child: FutureBuilder<BorderImages>(
                                  future: _borderImagesFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Text('Error loading borders'));
                                    } else if (snapshot.hasData) {
                                      // Wrap the Center widget with CustomPaint to paint the borders
                                      return Center(
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Image.asset(
                                                Assets.frame2, // File gambar frame
                                                fit: BoxFit
                                                    .fill, // Memastikan frame menyesuaikan seluruh area
                                              ),
                                            ),
                                            CustomPaint(
                                              child: FutureBuilder<List<SurahWord>>(
                                                  future: disabledWords,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return MushafBox(
                                                        surah: widget.surah,
                                                        scrollController:
                                                            _scrollController,
                                                        disabledWords: snapshot.data!,
                                                      );
                                                    } else {
                                                      return MushafBox(
                                                        surah: widget.surah,
                                                        scrollController:
                                                            _scrollController,
                                                      );
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: gap),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              NormalButton(
                                  // Button home
                                  height: context.isTablet() ? 64 : 48,
                                  width: context.isTablet() ? 64 : 48,
                                  onTap: () async {
                                    await audioPlayerEffect?.playClosePanel();
                                    Navigator.of(context).pop();
                                  },
                                  imageAsset: Assets.icHome),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: gap),
                    Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        Row(
                          //Dropdown select aya
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTapDown: (details) {
                                    setState(() {
                                      dropdownClicked = true;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      dropdownClicked = false;
                                    });
                                  },
                                  onTapUp: (details) {
                                    setState(() {
                                      dropdownClicked = false;
                                    });
                                    dropdownKey.currentContext
                                        ?.visitChildElements((element) {
                                      if (element.widget is Semantics) {
                                        element.visitChildElements((element) {
                                          if (element.widget is Actions) {
                                            element.visitChildElements((element) {
                                              Actions.invoke(
                                                  element, ActivateIntent());
                                            });
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: Image.asset(
                                    dropdownClicked
                                        ? Assets.frameWithPrefixClicked
                                        : Assets.frameWithPrefix,
                                    width: context.isTablet() ? 192 : 150,
                                    height: context.isTablet() ? 64 : 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Padding(
                                    padding: context.isTablet()
                                        ? const EdgeInsets.only(left: 70, right: 24)
                                        : const EdgeInsets.only(left: 55, right: 16),
                                    child: BlocBuilder<QuranBloc, QuranState>(
                                      buildWhen: (previous, current) =>
                                          current is QuranPlaying ||
                                          current is QuranIdle ||
                                          current is QuranLoading,
                                      builder: (context, state) {
                                        return DropdownButton(
                                          key: dropdownKey,
                                          icon: Container(),
                                          alignment: Alignment.centerRight,
                                          dropdownColor: QuranicTheme.primaryColor,
                                          hint: Text(
                                            _localization.aya,
                                            style: TextStyle(color: Colors.white),
                                            textAlign: TextAlign.start,
                                          ),
                                          value: max(
                                              _quranBloc.ayahs.isNotEmpty
                                                  ? _quranBloc.ayahs.first
                                                  : 0,
                                              _quranBloc.selectedAyahIndex),
                                          items: _quranBloc.ayahs.map((index) {
                                            String displayText = (index == 0)
                                                ? _localization.basmalah
                                                : _localization.aya_index_reversed(
                                                    convertToArabicNumbers(index,
                                                        locale: _localization.code));
                                            return DropdownMenuItem(
                                              value: index,
                                              child: Text(
                                                displayText,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textDirection: TextDirection.ltr,
                                              ),
                                            );
                                          }).toList(),
                                          onTap: () async {
                                            await audioPlayerEffect?.playOpenPanel();
                                          },
                                          onChanged: (int? newValue) {
                                            if (newValue != null) {
                                              _handleAyahSelection(newValue);
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          //Play, prev, next buttons
                          child: Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NormalButton(
                                height: context.isTablet() ? 64 : 48,
                                width: context.isTablet() ? 64 : 48,
                                onTap: () async {
                                  audioPlayerEffect?.playButton();
                                  _quranBloc.add(PlayNext());
                                },
                                imageAsset: Assets.icPrev,
                              ),
                              const SizedBox(width: 16),
                              BlocBuilder<QuranBloc, QuranState>(
                                builder: (context, state) {
                                  if (state is QuranPlaying) {
                                    return InkWell(
                                      onTap: () async {
                                        audioPlayerEffect?.playButton();
                                        _quranBloc.add(PauseQuran());
                                      },
                                      child: Image.asset(Assets.pause,
                                          width: context.isTablet() ? 80 : 64,
                                          height: context.isTablet() ? 80 : 64),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () async {
                                        audioPlayerEffect?.playButton();
                                        if (state is QuranPaused) {
                                          _quranBloc.add(ResumeQuran());
                                        } else if (state is QuranStopped) {
                                          _quranBloc.add(PlaySequential(
                                              startAya: state.currentAya));
                                        } else {
                                          _quranBloc.add(PlaySequential(startAya: 0));
                                        }
                                      },
                                      child: Image.asset(Assets.play,
                                          width: context.isTablet() ? 80 : 64,
                                          height: context.isTablet() ? 80 : 64),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 16),
                              NormalButton(
                                height: context.isTablet() ? 64 : 48,
                                width: context.isTablet() ? 64 : 48,
                                onTap: () async {
                                  audioPlayerEffect?.playButton();
                                  _quranBloc.add(PlayPrev());
                                },
                                imageAsset: Assets.icNext,
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<QuranBloc, QuranState>(
                          // Repeat buttons
                          buildWhen: (previous, current) {
                            return current is QuranPlaying || current is QuranStopped;
                          },
                          builder: (context, state) {
                            return SizedBox(
                              width: context.isTablet() ? 192 : 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                textDirection: TextDirection.ltr,
                                children: [
                                  NormalButton(
                                    height: context.isTablet() ? 64 : 48,
                                    width: context.isTablet() ? 64 : 48,
                                    onTap: () async {
                                      audioPlayerEffect?.playButton();
                                      if (!_quranBloc.isRepeating) {
                                        _quranBloc.add(PauseQuran());
                                        await audioPlayerEffect?.playOpenPanel();
                                        showGeneralDialog(
                                          context: context,
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return Container();
                                          },
                                          transitionBuilder: (context, animation,
                                              secondaryAnimation, child) {
                                            // Slide from bottom to center (y-axis starts from 1 and ends at 0)
                                            final slideTransition = Tween<Offset>(
                                              begin:
                                                  Offset(0, 1), // Starts from bottom
                                              end: Offset(0, 0), // Moves to center
                                            ).animate(CurvedAnimation(
                                              parent: animation,
                                              curve: Curves
                                                  .easeInOut, // Eases the animation in and out
                                            ));
          
                                            // Optional: Add fade effect during transition
                                            final fadeTransition = Tween<double>(
                                              begin: 0.0, // Start invisible
                                              end: 1.0, // Fully visible
                                            ).animate(CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut,
                                            ));
          
                                            return SlideTransition(
                                              position: slideTransition,
                                              child: FadeTransition(
                                                opacity: fadeTransition,
                                                child: ScaleTransition(
                                                  scale: Tween(begin: 0.8, end: 1.0)
                                                      .animate(CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeInOut,
                                                  )),
                                                  child: RepeatSettingsModal(
                                                    maxAya: _quranBloc.maxAya,
                                                    onSave: (repeatingCount, startAya,
                                                        endAya) {
                                                      _quranBloc.add(PlayRepeating(
                                                          startAya: startAya,
                                                          endAya: endAya,
                                                          repeatingCount:
                                                              repeatingCount));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        _quranBloc.add(StopRepeating());
                                      }
                                    },
                                    imageAsset: !_quranBloc.isRepeating
                                        ? Assets.icSetting
                                        : Assets.icStop,
                                    frameAsset: !_quranBloc.isRepeating
                                        ? Assets.btnNormal
                                        : Assets.btnGreen,
                                    frameClickedAsset: !_quranBloc.isRepeating
                                        ? Assets.btnClicked
                                        : Assets.btnGreenClicked,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isPlayAnimation)
            Container(
              height: double.infinity,
              width: double.infinity,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: HolePainter(
                          color: Colors.black,
                          holeSize: _splashAnimation.value * _size.width),
                    );
                  }),
            ),
      ],
    );
  }

  Scaffold _buildNormalLayout(double topMargin, double leftMargin,
      double rightMargin, BuildContext context, double botMargin) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.bg), // Background image
            fit: BoxFit.cover, // Ensure the image covers the whole screen
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: topMargin,
                left: leftMargin,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      Assets.circularProgressBook,
                      width: 64,
                      height: 64,
                    ),
                    BlocBuilder<ReadQuranCubit, ReadQuranState>(
                      builder: (context, state) {
                        if (state is ReadQuranWithData) {
                          return CircularPercentIndicator(
                            radius: 32,
                            percent: min(state.readCount / state.maxRead, 1),
                            progressColor: QuranicTheme.primaryColor,
                            backgroundColor: Colors.white.withOpacity(0.1),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                )),
            Positioned(
              top: topMargin,
              right: rightMargin,
              child: NormalButton(
                  height: context.isTablet() ? 64 : 48,
                  width: context.isTablet() ? 64 : 48,
                  onTap: () async {
                    await audioPlayerEffect?.playClosePanel();
                    Navigator.of(context).pop();
                  },
                  imageAsset: Assets.icHome),
            ),
            FutureBuilder<BorderImages>(
              future: _borderImagesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading borders'));
                } else if (snapshot.hasData) {
                  // Wrap the Center widget with CustomPaint to paint the borders
                  return Center(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            Assets.frame2, // File gambar frame
                            fit: BoxFit
                                .fill, // Memastikan frame menyesuaikan seluruh area
                          ),
                        ),
                        CustomPaint(
                          child: FutureBuilder<List<SurahWord>>(
                              future: disabledWords,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return MushafBox(
                                    surah: widget.surah,
                                    scrollController: _scrollController,
                                    disabledWords: snapshot.data!,
                                  );
                                } else {
                                  return MushafBox(
                                    surah: widget.surah,
                                    scrollController: _scrollController,
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            Positioned(
              bottom: context.isTablet() ? 24 : 0,
              left: 0,
              right: 0,
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NormalButton(
                    height: context.isTablet() ? 64 : 48,
                    width: context.isTablet() ? 64 : 48,
                    onTap: () async {
                      audioPlayerEffect?.playButton();
                      _quranBloc.add(PlayNext());
                    },
                    imageAsset: Assets.icPrev,
                  ),
                  const SizedBox(width: 16),
                  BlocBuilder<QuranBloc, QuranState>(
                    builder: (context, state) {
                      if (state is QuranPlaying) {
                        return InkWell(
                          onTap: () async {
                            audioPlayerEffect?.playButton();
                            _quranBloc.add(PauseQuran());
                          },
                          child: Image.asset(Assets.pause,
                              width: context.isTablet() ? 80 : 64,
                              height: context.isTablet() ? 80 : 64),
                        );
                      } else {
                        return InkWell(
                          onTap: () async {
                            audioPlayerEffect?.playButton();
                            if (state is QuranPaused) {
                              _quranBloc.add(ResumeQuran());
                            } else if (state is QuranStopped) {
                              _quranBloc.add(
                                  PlaySequential(startAya: state.currentAya));
                            } else {
                              _quranBloc.add(PlaySequential(startAya: 0));
                            }
                          },
                          child: Image.asset(Assets.play,
                              width: context.isTablet() ? 80 : 64,
                              height: context.isTablet() ? 80 : 64),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 16),
                  NormalButton(
                    height: context.isTablet() ? 64 : 48,
                    width: context.isTablet() ? 64 : 48,
                    onTap: () async {
                      audioPlayerEffect?.playButton();
                      _quranBloc.add(PlayPrev());
                    },
                    imageAsset: Assets.icNext,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: botMargin - 8,
              left: leftMargin + 16,
              child: Row(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTapDown: (details) {
                          setState(() {
                            dropdownClicked = true;
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            dropdownClicked = false;
                          });
                        },
                        onTapUp: (details) {
                          setState(() {
                            dropdownClicked = false;
                          });
                          dropdownKey.currentContext
                              ?.visitChildElements((element) {
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
                        child: Image.asset(
                          dropdownClicked
                              ? Assets.frameWithPrefixClicked
                              : Assets.frameWithPrefix,
                          width: context.isTablet() ? 192 : 150,
                          height: context.isTablet() ? 64 : 50,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: context.isTablet()
                              ? const EdgeInsets.only(left: 70, right: 24)
                              : const EdgeInsets.only(left: 55, right: 16),
                          child: BlocBuilder<QuranBloc, QuranState>(
                            buildWhen: (previous, current) =>
                                current is QuranPlaying ||
                                current is QuranIdle ||
                                current is QuranLoading,
                            builder: (context, state) {
                              return DropdownButton(
                                key: dropdownKey,
                                icon: Container(),
                                alignment: Alignment.centerRight,
                                dropdownColor: QuranicTheme.primaryColor,
                                hint: Text(
                                  _localization.aya,
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                value: max(
                                    _quranBloc.ayahs.isNotEmpty
                                        ? _quranBloc.ayahs.first
                                        : 0,
                                    _quranBloc.selectedAyahIndex),
                                items: _quranBloc.ayahs.map((index) {
                                  String displayText = (index == 0)
                                      ? _localization.basmalah
                                      : _localization.aya_index_reversed(
                                          convertToArabicNumbers(index,
                                              locale: _localization.code));
                                  return DropdownMenuItem(
                                    value: index,
                                    child: Text(
                                      displayText,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textDirection: TextDirection.ltr,
                                    ),
                                  );
                                }).toList(),
                                onTap: () async {
                                  await audioPlayerEffect?.playOpenPanel();
                                },
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    _handleAyahSelection(newValue);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: botMargin,
              right: rightMargin,
              child: BlocBuilder<QuranBloc, QuranState>(
                buildWhen: (previous, current) {
                  return current is QuranPlaying || current is QuranStopped;
                },
                builder: (context, state) {
                  return NormalButton(
                    height: context.isTablet() ? 64 : 48,
                    width: context.isTablet() ? 64 : 48,
                    onTap: () async {
                      audioPlayerEffect?.playButton();
                      if (!_quranBloc.isRepeating) {
                        _quranBloc.add(PauseQuran());
                        await audioPlayerEffect?.playOpenPanel();
                        showGeneralDialog(
                          context: context,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return Container();
                          },
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // Slide from bottom to center (y-axis starts from 1 and ends at 0)
                            final slideTransition = Tween<Offset>(
                              begin: Offset(0, 1), // Starts from bottom
                              end: Offset(0, 0), // Moves to center
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves
                                  .easeInOut, // Eases the animation in and out
                            ));

                            // Optional: Add fade effect during transition
                            final fadeTransition = Tween<double>(
                              begin: 0.0, // Start invisible
                              end: 1.0, // Fully visible
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ));

                            return SlideTransition(
                              position: slideTransition,
                              child: FadeTransition(
                                opacity: fadeTransition,
                                child: ScaleTransition(
                                  scale: Tween(begin: 0.8, end: 1.0)
                                      .animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  )),
                                  child: RepeatSettingsModal(
                                    maxAya: _quranBloc.maxAya,
                                    onSave: (repeatingCount, startAya, endAya) {
                                      _quranBloc.add(PlayRepeating(
                                          startAya: startAya,
                                          endAya: endAya,
                                          repeatingCount: repeatingCount));
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        _quranBloc.add(StopRepeating());
                      }
                    },
                    imageAsset: !_quranBloc.isRepeating
                        ? Assets.icSetting
                        : Assets.icStop,
                    frameAsset: !_quranBloc.isRepeating
                        ? Assets.btnNormal
                        : Assets.btnGreen,
                    frameClickedAsset: !_quranBloc.isRepeating
                        ? Assets.btnClicked
                        : Assets.btnGreenClicked,
                  );
                },
              ),
            ),
            // Positioned(
            //   bottom: -20,
            //   right: 80,
            //   child: BlocBuilder<AuthBoyCubit, AuthBoyState>(
            //     builder: (context, state) {
            //       return GestureDetector(
            //         onTap: () async {
            //           await audioPlayerEffect?.playOpenPanel();
            //           if (state is AuthBoyWithSession) {
            //             Navigator.of(context).pushNamed(
            //                 AppRoutes.memorization,
            //                 arguments: widget.lesson);
            //           } else {
            //             SystemChrome.setPreferredOrientations([
            //               DeviceOrientation.portraitDown,
            //               DeviceOrientation.portraitUp,
            //             ]);
            //             Navigator.of(context)
            //                 .pushNamed(AppRoutes.loginStudents)
            //                 .then((_) {
            //               SystemChrome.setPreferredOrientations([
            //                 DeviceOrientation.landscapeRight,
            //                 DeviceOrientation.landscapeLeft,
            //               ]);
            //             });
            //           }
            //         },
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             // Star image
            //             Container(
            //               width: 100,
            //               height: 100,
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: AssetImage(themeCubit.theme.bintang),
            //                   fit: BoxFit.contain,
            //                 ),
            //               ),
            //             ),
            //             // Progress bar positioned below the star image
            //             Positioned(
            //               bottom: 42.5,
            //               right: 12.5,
            //               child: Container(
            //                 width: 60,
            //                 height: 15,
            //                 child: BlocBuilder<StarCubit, StarState>(
            //                   buildWhen: (_, current) =>
            //                       current is StarSaved ||
            //                       current is StarLoaded,
            //                   builder: (context, state) {
            //                     double memorizationProgress = 0;
            //                     if (state is StarSaved) {
            //                       memorizationProgress =
            //                           state.star.toDouble() /
            //                               state.maxStar.toDouble();
            //                     }
            //                     return FractionallySizedBox(
            //                       widthFactor: memorizationProgress.clamp(0.0,
            //                           1.0), // Use the memorization progress as the width factor
            //                       alignment: Alignment
            //                           .centerLeft, // Fill from left to right
            //                       child: Container(
            //                         decoration: BoxDecoration(
            //                           color: Colors
            //                               .yellow, // Color of the progress
            //                           borderRadius: BorderRadius.circular(
            //                               4), // Match the corner radius
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
