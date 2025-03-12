import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/presentations/features/quran/bloc/quran_bloc.dart';
import 'package:juz_amma_kids/presentations/features/quran/memorization/cubit/memorization_cubit.dart';
import 'package:juz_amma_kids/presentations/features/quran/memorization/memorization_screen.dart';
import 'package:juz_amma_kids/presentations/features/quran/recitation/cubit/read_quran_cubit.dart';
import 'package:juz_amma_kids/presentations/features/quran/recitation/quran_screen.dart';
import 'package:juz_amma_kids/presentations/features/quran/widgets/cubit/mushaf_cubit.dart';
import 'package:juz_amma_kids/presentations/features/select_display_mode/select_display_mode.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/sora_list.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/sora_list_memorization.dart';
import 'package:juz_amma_kids/presentations/features/select_surah/sora_menu.dart';
import 'package:juz_amma_kids/route/app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return buildRoute(SelectDisplayMode(), settings: settings);

      case AppRoutes.selectSurah:
        return buildRoute(SurahMenuPage(), settings: settings);

      case AppRoutes.selectSurahList:
        return buildRoute(SoraList(), settings: settings);

      case AppRoutes.selectSurahListMemorization:
        return buildRoute(SoraListMemorization(), settings: settings);

      case AppRoutes.selectDisplay:
        return buildRoute(SelectDisplayMode(), settings: settings);

      case AppRoutes.quran:
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        final arguments = settings.arguments as Surah;
        return buildRoute(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => QuranBloc(arguments)),
                BlocProvider(create: (context) => MushafCubit()),
                BlocProvider(create: (context) => ReadQuranCubit(arguments)),
              ],
              child: QuranScreen(surah: arguments),
            ),
            settings: settings);

      case AppRoutes.memorization:
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        final arguments = settings.arguments as Surah;
        return buildRoute(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => QuranBloc(arguments)),
                BlocProvider(create: (context) => MushafCubit()),
                BlocProvider(create: (context) => MemorizationCubit()),
              ],
              child: MemorizationScreen(lesson: arguments),
            ),
            settings: settings);

      default:
        return buildRoute(SurahMenuPage(), settings: settings);
    }
  }

  static MaterialPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute(settings: settings, builder: (context) => child);
  }
}
