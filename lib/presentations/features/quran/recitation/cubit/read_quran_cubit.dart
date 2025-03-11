import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/services/database_service.dart';
part 'read_quran_state.dart';

class ReadQuranCubit extends Cubit<ReadQuranState> {
  ReadQuranCubit(this.surah) : super(ReadQuranInitial());

  final DatabaseService _databaseService = DatabaseService();
  
  final Surah surah;

  init() async {
    final readAya = await _databaseService.getReadAya(surah: surah);
    emit(ReadQuranWithData(readCount: readAya.values.where((e) => e).length, maxRead: readAya.values.length));
  }

  markAsRead(int ayaIndex) async {
    final result = await _databaseService.insertReadAya(surah: surah, ayaIndex: ayaIndex, value: true);
    emit(ReadQuranWithData(readCount: result.values.where((e) => e).length, maxRead: result.values.length));
  }
}
