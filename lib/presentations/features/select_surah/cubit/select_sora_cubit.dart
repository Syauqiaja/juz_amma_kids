import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/core/model/memorization_model.dart';
import 'package:juz_amma_kids/core/services/database_service.dart';

part 'select_sora_state.dart';

class SelectSoraCubit extends Cubit<SelectSoraState> {
  SelectSoraCubit() : super(SelectSoraInitial());

  final DatabaseService _databaseService = DatabaseService();

  load() async {
    emit(SelectSoraLoading());
    try {
      final result = await _databaseService.getSurahs();
      emit(SelectSoraWithData(surahs: result));
    } catch (e) {
      print(e);
      emit(SelectSoraError(message: e.toString()));
    }
  }

  update(int soraId) async {
    if (state is SelectSoraWithData) {
      print('Updating selectsorawithdata');
      final index = (state as SelectSoraWithData)
          .surahs
          .indexWhere((e) => e.soraIndex == soraId);

      final result = await _databaseService.getSurah(soraId);
      final copiedList = (state as SelectSoraWithData).surahs;
      copiedList[index] = result;

      emit(SelectSoraWithData(surahs: copiedList));
      print('emitting selectsorawithdata');
    }
  }

  refresh() {
    final copiedList = (state as SelectSoraWithData).surahs;
    emit(SelectSoraLoading());
    emit(SelectSoraWithData(surahs: copiedList));
  }
}
