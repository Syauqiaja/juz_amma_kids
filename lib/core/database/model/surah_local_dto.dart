import 'package:drift/drift.dart';
import 'package:juz_amma_kids/core/database/quran_database/quran_database.dart';
import 'package:juz_amma_kids/core/model/surah_word.dart';

class SurahLocalDto extends Insertable<SurahLocalDto> {
  final int id;
  final int page;
  final int sora;
  final int aya;
  final int line;
  final String word;

  SurahLocalDto(
      {required this.id,
      required this.page,
      required this.sora,
      required this.aya,
      required this.line,
      required this.word});

  SurahWord toDomain() {
    return SurahWord(
      id: id,
      page: page,
      sora: sora,
      aya: aya,
      line: line,
      word: word,
    );
  }

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return TableSurahsCompanion(
      id: Value(id),
      page: Value(page),
      sora: Value(sora),
      aya: Value(aya),
      line: Value(line),
      word: Value(word),
    ).toColumns(nullToAbsent);
  }
}
