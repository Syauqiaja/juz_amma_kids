import 'package:drift/drift.dart';
import 'package:http/http.dart';
import 'package:juz_amma_kids/core/database/app_database/app_database.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/model/surah_word.dart';
import 'package:juz_amma_kids/core/database/model/surah_local_dto.dart';
import 'package:juz_amma_kids/core/database/quran_database/quran_database.dart';
import 'package:juz_amma_kids/core/database/tables/table_surahs.dart';
part 'surah_dao.g.dart';

@DriftAccessor(tables: [TableSurahs])
class SurahDao extends DatabaseAccessor<QuranDatabase> with _$SurahDaoMixin {
  SurahDao(this.db) : super(db);

  final QuranDatabase db;

  Future<List<SurahLocalDto>> getAllSurahs() async {
    return select(tableSurahs).get();
  }

  Future<List<SurahLocalDto>> searchBySurahIndex(int soraIndex) async {
    return (select(tableSurahs)..where((u) => u.sora.isValue(soraIndex))).get();
  }

  Future<int> getTotalAyaOfSurah(int soraIndex) async {
    final ayaCount = tableSurahs.aya.count();
    final query = select(tableSurahs)..where((e) => e.sora.equals(soraIndex));
    final added = query.addColumns([ayaCount]);
    added.groupBy([tableSurahs.aya]);
    final result = await added.getSingle();

    return result.read(ayaCount) ?? 0;
  }

  Future<List<Surah>> getSurahs() async {
    final query = selectOnly(tableSurahs)
      ..where(tableSurahs.sora.isBiggerThanValue(77))
      ..orderBy([OrderingTerm.desc(tableSurahs.sora)])
      ..addColumns([tableSurahs.sora]);
    query.groupBy([tableSurahs.sora]);
    final ids = await query.get();

    final List<Surah> lessons = [];
    for (var i = 0; i < ids.length; i++) {
      lessons
          .add(await getSurah(ids[i].read(tableSurahs.sora)!));
    }

    return lessons;
  }

  Future<Surah> getSurah(int soraIndex) async {
    final query = select(tableSurahs)
      ..where((e) => e.sora.equals(soraIndex));
    final results = await query.get();

    return Surah.fromSurahDto(results);
  }

  Future<List<SurahWord>> getDisabledWords(int surah) async {
    final selectedSurahQuery = select(tableSurahs)
      ..where((e) => e.sora.equals(surah))
      ..limit(1);
    final selectedSurah = await selectedSurahQuery.getSingle();
    final query = select(tableSurahs)
      ..where((e) => e.page.equals(selectedSurah.page))
      ..where((e) => e.line.equals(selectedSurah.line))
      ..where((e) => e.sora.equals(selectedSurah.sora))
      ..where((e) => e.id.isSmallerThanValue(selectedSurah.id));
    return (await query.get()).map((e) => e.toDomain()).toList();
  }
}
