import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:juz_amma_kids/core/model/language_entity.dart';
import 'package:juz_amma_kids/utils/user_prefs.dart';
part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(LocalizationInitial(Locale("id"))) {
    on<LoadLocalization>(_onLoadLocalization);
    on<SaveLocalization>(_onSaveLocalization);
  }

  Future<void> _onLoadLocalization(LoadLocalization event, Emitter<LocalizationState> emit) async {
    emit(LocalizationLoaded(Locale(UserPrefs.instance.getString("lang") ?? "id")));
  }

  Future<void> _onSaveLocalization(SaveLocalization event, Emitter<LocalizationState> emit) async {
    UserPrefs.instance.setString("lang", event.language.code);
    emit(LocalizationLoaded(Locale(event.language.code)));
  }
}
