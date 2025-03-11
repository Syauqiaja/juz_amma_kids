import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:juz_amma_kids/core/model/language_entity.dart';
import 'package:juz_amma_kids/presentations/features/menu/bloc/localization_bloc.dart';
import 'package:juz_amma_kids/presentations/features/quran/recitation/cubit/star_cubit.dart';
import 'package:juz_amma_kids/presentations/features/select_display_mode/select_display_mode.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/cubit/select_sora_cubit.dart';
import 'package:juz_amma_kids/route/app_routes.dart';
import 'package:juz_amma_kids/route/route_generator.dart';
import 'package:juz_amma_kids/utils/user_prefs.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


late AppLocalizations localization;
FlutterSoundPlayer? audioPlayerEffect = FlutterSoundPlayer(logLevel: Level.off)..openPlayer();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserPrefs.instance.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => StarCubit()),
        BlocProvider(
            create: (context) => LocalizationBloc()..add(LoadLocalization())),
        BlocProvider(create: (context) => SelectSoraCubit()),
      ],
      child: const MyApp(),
    ));
  });
}

initAudio() async {
  audioPlayerEffect = await FlutterSoundPlayer().openPlayer();

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

  print("Audio finished loading on main");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initAudio();

    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, localizationState) {
        return Sizer(
          builder: (context, orientation, screenType) {
            return MaterialApp(
              title: 'Qurany',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
                useMaterial3: true,
              ),
          onGenerateTitle: (context){
            return "Juz Amma For Kids";
          },
              onGenerateRoute: RouteGenerator.generateRoute,
              initialRoute: AppRoutes.home,
              home: SelectDisplayMode(),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales:
                  Languages.allLanguages.map((e) => Locale(e.code)).toList(),
              locale: localizationState.locale,
            );
          }
        );
      },
    );
  }
}
