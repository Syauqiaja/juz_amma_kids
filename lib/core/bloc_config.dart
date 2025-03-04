import 'package:flutter_bloc/flutter_bloc.dart';

class BlocConfig {
  List<BlocProvider> allProviders = [
    BlocProvider(create: (context) => StarCubit()),
    BlocProvider(create: (context) => ThemeCubit()),
    BlocProvider(create: (context) => AuthBoyCubit()),
    BlocProvider(create: (context) => LocalizationBloc()..add(LoadLocalization())),
  ];
}
