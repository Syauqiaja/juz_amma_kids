import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
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
}
