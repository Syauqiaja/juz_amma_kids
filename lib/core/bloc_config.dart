import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juz_amma_kids/presentations/features/menu/bloc/localization_bloc.dart';
import 'package:juz_amma_kids/presentations/features/quran/recitation/cubit/star_cubit.dart';

class BlocConfig {
  List<BlocProvider> allProviders = [
    BlocProvider(create: (context) => StarCubit()),
    BlocProvider(create: (context) => LocalizationBloc()..add(LoadLocalization())),
  ];
}
