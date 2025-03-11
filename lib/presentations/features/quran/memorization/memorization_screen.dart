import 'dart:io';
import 'dart:math';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/model/surah_word.dart';
import 'package:juz_amma_kids/core/services/database_service.dart';
import 'package:juz_amma_kids/core/services/resource_loader.dart';
import 'package:juz_amma_kids/global/z-global.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/main.dart';
import 'package:juz_amma_kids/presentations/features/quran/memorization/cubit/memorization_cubit.dart';
import 'package:juz_amma_kids/presentations/features/quran/memorization/memorization_mushaf_box.dart';
import 'package:juz_amma_kids/presentations/features/quran/widgets/cubit/mushaf_cubit.dart';
import 'package:juz_amma_kids/presentations/modals/button_scalable.dart';
import 'package:juz_amma_kids/presentations/modals/normal_button.dart';
import 'package:juz_amma_kids/utils/audio_player_ext.dart';
import 'package:juz_amma_kids/utils/context_ext.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';
import '../../../../utils/user_prefs.dart';
import '../bloc/quran_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MemorizationScreen extends StatefulWidget {
  final Surah lesson;
  const MemorizationScreen({super.key, required this.lesson});

  @override
  State<MemorizationScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<MemorizationScreen>
    with SingleTickerProviderStateMixin {
  late QuranBloc _quranBloc;
  late AppLocalizations _localization;
  late Future<BorderImages> _borderImagesFuture;
  late MemorizationCubit _memorizationCubit;
  FlutterSoundPlayer? _audioPlayer =
      FlutterSoundPlayer(logLevel: Level.off); // Initialize FlutterSoundPlayer
  FlutterSoundPlayer? _audioPlayerEffect = FlutterSoundPlayer(logLevel: Level.off);
  int repeatCountdown = 0;
  ScrollController _scrollController = ScrollController();
  bool dropdownClicked = false;
  GlobalKey dropdownKey = GlobalKey(debugLabel: "dropdown_select_ayah");
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _recordingPath = '';
  late Future<List<SurahWord>> disabledWords;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;

  bool _canPlayEffect = true;
  final String sfxSettingKey = "is_memorization_sfx_on";

  @override
  void initState() {
    super.initState();
    _quranBloc = BlocProvider.of<QuranBloc>(context);
    _memorizationCubit = BlocProvider.of(context);
    disabledWords = DatabaseService()
        .getDisabledWords(widget.lesson.soraIndex);
    initAudio();

    _memorizationCubit.init(widget.lesson);

    _borderImagesFuture = Globals.loadBorderImages();

    _quranBloc.add(LoadQuran(
        surahIndex: widget.lesson.soraIndex));

    initAnimation();

    _canPlayEffect = UserPrefs.instance.getBool(sfxSettingKey) ?? true;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    precacheImage(
        new AssetImage(Assets.btnFrameOrangeClicked), context);
    precacheImage(new AssetImage(Assets.btnClicked), context);
    precacheImage(new AssetImage(Assets.icPause), context);
    precacheImage(new AssetImage(Assets.icStop), context);
    precacheImage(
        new AssetImage(Assets.frameWithPrefixClicked), context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    disposeAudio();
    super.dispose();
  }

  initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.995)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);

    _positionAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: Offset.zero, end: const Offset(3, 0)), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(3, 0), end: const Offset(-3, 0)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: const Offset(-3, 0), end: Offset.zero),
          weight: 1),
    ]).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  initAudio() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    session.setActive(true);

    _audioPlayer = await FlutterSoundPlayer(logLevel: Level.off).openPlayer();
    _audioPlayerEffect = await FlutterSoundPlayer(logLevel: Level.off).openPlayer();

    await _recorder!.openRecorder();

    print("Audio finished loading");
  }

  disposeAudio() async {
    _audioPlayer?.stopPlayer();
    _audioPlayer?.closePlayer();

    await _recorder!.closeRecorder();

    final session = await AudioSession.instance;
    session.setActive(false);

    _audioPlayerEffect?.stopPlayer();
    _audioPlayerEffect?.closePlayer();
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

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<void> _startRecording() async {
    try {
      if(kIsWeb){
        _recordingPath = 'cache/${_generateRandomId()}';
      }else{
        _recordingPath = await getApplicationDocumentsDirectory()
            .then((value) => '${value.path}/${_generateRandomId()}.aac');
      }
      // _recordingPath = Directory('/storage/emulated/0/Download').path + '/${_generateRandomId()}.aac';
      // Start recording without assigning it to a variable
      await _recorder!.startRecorder(
        toFile: _recordingPath,
        codec: kIsWeb? Codec.defaultCodec : Codec.aacADTS,
      );

      setState(() {
        _isRecording = true;
      });

      print("Recording started...");
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<File?> moveFileToDownloads(String sourcePath) async {
    try {
      // Get the Downloads directory
      final downloadsDirectory = Directory('/storage/emulated/0/Download');

      if (await downloadsDirectory.exists()) {
        // Create a new file path in the Downloads directory
        final fileName = sourcePath.split('/').last; // Extract the file name
        final newPath = '${downloadsDirectory.path}/$fileName';

        // Move the file
        final sourceFile = File(sourcePath);
        final newFile = await sourceFile.copy(newPath);
        await sourceFile.delete();

        print('File moved to: $newPath');
        return newFile;
      } else {
        print('Downloads directory does not exist');
      }
      return null;
    } catch (e) {
      print('Error moving file: $e');
      return null;
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _recorder!.stopRecorder();
      print("Started to stop recording for : $path");

      if (path != null) {
        if (kDebugMode && !kIsWeb) {
          if(Platform.isAndroid){
            final newFile = await moveFileToDownloads(path);
            path = newFile?.path;
          }
        }

        if (path == null) {
          print("Failed to stop recording. File failed to copied to download");
          return;
        }

        setState(() {
          _isRecording = false;
          _recordingPath = path!;
        });
        print("Recording stopped and saved at $path");
        await accessFile(path);
      } else {
        print("Failed to stop recording. path is null");
      }
    } catch (e, s) {
      print("Error stopping recording: $e");
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> accessFile(String filePath) async {
    try {
      // Check if the file exists
      final file = File(filePath);
      if(kIsWeb){
        _memorizationCubit.submitForWeb(XFile(filePath), _memorizationCubit.currentAya);
      }else{
        _memorizationCubit.submit(file, _memorizationCubit.currentAya);
      }
      if (await file.exists()) {
        print('File found: $filePath');
        // Perform operations on the file
        final fileContent =
            await file.readAsBytes(); // Example: Read file as bytes

        print('Playing audio...');
        print('File size: ${fileContent.length} bytes');
      } else {
        print('File does not exist: $filePath');
      }
    } catch (e) {
      print('Error accessing file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    final double topMargin = context.isTablet() ? 48 : 24;
    final double botMargin = context.isTablet() ? 48 : 24;
    final double leftMargin = context.isTablet() ? 48 : 24;
    final double rightMargin = context.isTablet() ? 48 : 24;
    final double gap = context.isTablet() ? 24 : 16;

    print("App height : ${MediaQuery.of(context).size.height}");
    return MultiBlocListener(
      listeners: [
        BlocListener<MushafCubit, MushafState>(
          listener: (context, state) {
            if (state.selectedAyahIndex > 0) {
              _jumpTo(state.selectedAyahIndex);
            }
          },
        ),
        BlocListener<MemorizationCubit, MemorizationState>(
          listener: (context, state) async {
            if (state is MemorizationWithData) {
              if (state.message != null) {
                _animationController.forward();
                if (_canPlayEffect) {
                  audioPlayerEffect?.playError();
                }
                _audioPlayer?.startPlayer(
                    fromDataBuffer: await ResourceLoader.getRecitation(
                        _memorizationCubit.surah.soraIndex,
                        _memorizationCubit.currentAya));
                if (await Vibration.hasCustomVibrationsSupport()) {
                  Vibration.vibrate(duration: 500);
                } else {
                  HapticFeedback.heavyImpact();
                  await Future.delayed(Duration(milliseconds: 200));
                  HapticFeedback.heavyImpact();
                  await Future.delayed(Duration(milliseconds: 200));
                  HapticFeedback.heavyImpact();
                }
              }
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.bg), // Background image
              fit: BoxFit.cover, // Ensure the image covers the whole screen
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: topMargin,
              bottom: botMargin,
              left: leftMargin,
              right: rightMargin,
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: context.isTablet() ? 64 : 48,
                    )
                  ],
                ),
                SizedBox(width: gap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1.7,
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: _positionAnimation.value,
                                  child: Transform.scale(
                                    scale: _scaleAnimation.value,
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
                                                          return MemorizationMushafBox(
                                                            surah: widget.lesson,
                                                            scrollController:
                                                                _scrollController,
                                                            disabledWords:
                                                                snapshot.data!,
                                                          );
                                                        } else {
                                                          return MemorizationMushafBox(
                                                            surah: widget.lesson,
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
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: gap),
                      Row(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 16),
                          BlocBuilder<QuranBloc, QuranState>(
                            builder: (context, state) {
                              return InkWell(
                                onTap: () async {
                                  audioPlayerEffect?.playButton();
                              
                                  if (_memorizationCubit.state
                                      is MemorizationLoading) return;
                              
                                  if (_isRecording) {
                                    await _stopRecording();
                                    print(
                                        "Recording stopped and saved at $_recordingPath");
                                  } else {
                                    await _startRecording();
                                    print("Recording started...");
                                  }
                              
                                  // setState(() {
                                  //   _isRecording = !_isRecording;
                                  // });
                                },
                                child: BlocBuilder<MemorizationCubit,
                                    MemorizationState>(
                                  builder: (context, state) {
                                    if (state is MemorizationLoading) {
                                      return NormalButton(
                                        onTap: () {},
                                        imageAsset: null,
                                        height: context.isTablet() ? 80 : 64,
                                        width: context.isTablet() ? 80 : 64,
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (state is MemorizationDone) {
                                      return ButtonScalable(
                                          height: context.isTablet() ? 64 : 45,
                                          width: context.isTablet() ? 341 : 240,
                                          child: Text(
                                            _localization.back_to_home,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    context.isTablet() ? 18 : 16),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          });
                                    } else {
                                      return Image.asset(
                                        _isRecording
                                            ? Assets.btnRecordClicked
                                            : Assets.btnRecord,
                                        width: context.isTablet() ? 80 : 64,
                                        height: context.isTablet() ? 80 : 64,
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: gap),
                Column(
                  children: [
                    NormalButton(
                        height: context.isTablet() ? 64 : 48,
                        width: context.isTablet() ? 64 : 48,
                        onTap: () async {
                          await _audioPlayerEffect?.startPlayer(
                              fromDataBuffer: await ResourceLoader.getFromAsset(
                                  'assets/voice/close panel.flac'));
                          Navigator.of(context).pop();
                        },
                        imageAsset: Assets.icHome),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: NormalButton(
                            height: context.isTablet() ? 64 : 48,
                            width: context.isTablet() ? 64 : 48,
                            imageAsset: _canPlayEffect
                                ? Assets.speakerOn
                                : Assets.speakerOff,
                            onTap: () {
                              setState(() {
                                _canPlayEffect = !_canPlayEffect;
                              });
                              _audioPlayer?.setVolume(_canPlayEffect ? 1 : 0);
                              UserPrefs.instance
                                  .setBool(sfxSettingKey, _canPlayEffect);
                            },
                          )),
                        ],
                      ),
                    ),
                    NormalButton(
                      height: context.isTablet() ? 64 : 48,
                      width: context.isTablet() ? 64 : 48,
                      onTap: () async {
                        await audioPlayerEffect?.playButton();
                        _memorizationCubit
                            .reset(); // Reset all memorization state
                        print("Memorization reset shortcut all aya.");
                      },
                      imageAsset: Assets.icRepeat,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack _buildOldLayout(double topMargin, double rightMargin,
      BuildContext context, double botMargin) {
    return Stack(
      children: [
        Positioned(
          top: topMargin,
          right: rightMargin,
          child: NormalButton(
              height: context.isTablet() ? 64 : 48,
              width: context.isTablet() ? 64 : 48,
              onTap: () async {
                await _audioPlayerEffect?.startPlayer(
                    fromDataBuffer: await ResourceLoader.getFromAsset(
                        'assets/voice/close panel.flac'));
                Navigator.of(context).pop();
              },
              imageAsset: Assets.icHome),
        ),
        Positioned(
          right: rightMargin,
          top: 0,
          bottom: 0,
          child: Center(
              child: NormalButton(
            height: context.isTablet() ? 64 : 48,
            width: context.isTablet() ? 64 : 48,
            imageAsset: _canPlayEffect
                ? Assets.speakerOn
                : Assets.speakerOff,
            onTap: () {
              setState(() {
                _canPlayEffect = !_canPlayEffect;
              });
              _audioPlayer?.setVolume(_canPlayEffect ? 1 : 0);
              UserPrefs.instance.setBool(sfxSettingKey, _canPlayEffect);
            },
          )),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: _positionAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: FutureBuilder<BorderImages>(
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
                                      return MemorizationMushafBox(
                                        surah: widget.lesson,
                                        scrollController: _scrollController,
                                        disabledWords: snapshot.data!,
                                      );
                                    } else {
                                      return MemorizationMushafBox(
                                        surah: widget.lesson,
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
              ),
            );
          },
        ),
        Positioned(
          bottom: botMargin, // Position from the bottom
          right: rightMargin, // Position from the right
          child: NormalButton(
            height: context.isTablet() ? 64 : 48,
            width: context.isTablet() ? 64 : 48,
            onTap: () async {
              await audioPlayerEffect?.playButton();
              _memorizationCubit.reset(); // Reset all memorization state
              print("Memorization reset shortcut all aya.");
            },
            imageAsset: Assets.icRepeat,
          ),
        ),
        Positioned(
          bottom: context.isTablet() ? 24 : 0,
          left: 0,
          right: 0,
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              BlocBuilder<QuranBloc, QuranState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () async {
                      audioPlayerEffect?.playButton();

                      if (_memorizationCubit.state is MemorizationLoading)
                        return;

                      if (_isRecording) {
                        await _stopRecording();
                        print("Recording stopped and saved at $_recordingPath");
                      } else {
                        await _startRecording();
                        print("Recording started...");
                      }

                      // setState(() {
                      //   _isRecording = !_isRecording;
                      // });
                    },
                    child: BlocBuilder<MemorizationCubit, MemorizationState>(
                      builder: (context, state) {
                        if (state is MemorizationLoading) {
                          return NormalButton(
                            onTap: () {},
                            imageAsset: null,
                            child: CircularProgressIndicator(),
                            height: context.isTablet() ? 80 : 64,
                            width: context.isTablet() ? 80 : 64,
                          );
                        } else if (state is MemorizationDone) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: ButtonScalable(
                                height: context.isTablet() ? 64 : 45,
                                width: context.isTablet() ? 341 : 240,
                                child: Text(
                                  _localization.back_to_home,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: context.isTablet() ? 18 : 16),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                }),
                          );
                        } else {
                          return Image.asset(
                            _isRecording
                                ? Assets.btnRecordClicked
                                : Assets.btnRecord,
                            width: context.isTablet() ? 80 : 64,
                            height: context.isTablet() ? 80 : 64,
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
