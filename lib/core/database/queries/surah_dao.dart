import 'package:drift/drift.dart';
import 'package:http/http.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/database/model/surah_local_dto.dart';
import 'package:juz_amma_kids/database/quran_database/quran_database.dart';
import 'package:juz_amma_kids/database/tables/table_surahs.dart';
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

  Future<int> getTotalAyaOfLesson(int lessonIndex, int year) async {
    final ayaCount = tableSurahs.aya.count();
    final query = select(tableSurahs)
      ..where((e) => e.lesson.equals(lessonIndex))
      ..where((e) => e.year.equals(year));
    final added = query.addColumns([ayaCount])..groupBy([tableSurahs.aya]);

    final result = await added.getSingle();
    return result.read(ayaCount) ?? 0;
  }

  Future<List<int>> getAyahsOfLesson(int lessonIndex, int year) async {
    final query = selectOnly(tableSurahs)
      ..addColumns([tableSurahs.aya])
      ..where(tableSurahs.lesson.equals(lessonIndex))
      ..where(tableSurahs.year.equals(year));
    final result = await query.get();
    return result.map((e) => e.read(tableSurahs.aya) ?? 0).toList();
  }


  Future<Map<int, List<Lesson>>> getLessonsOfYears(List<int> years) async {
    final Map<int, List<Lesson>> lessonOfYears = {};

    for (int year in years) {
      lessonOfYears[year] = await getLessons(year);
    }
    return lessonOfYears;
  }

  Future<List<Map<String, int>>> queryLessonOfYear(int year) async {
    final query = selectOnly(tableSurahs)
      ..addColumns([tableSurahs.lesson, tableSurahs.sora])
      ..where(tableSurahs.year.equals(year))
      ..groupBy([tableSurahs.lesson])
      ..orderBy([
        OrderingTerm(expression: tableSurahs.lesson),
        OrderingTerm(expression: tableSurahs.sora)
      ]);

    final result = await query.get();

    return result
        .map((e) => {
              'lesson': e.read(tableSurahs.lesson)!,
              'sora': e.read(tableSurahs.sora)!
            })
        .toList();
  }

  Future<List<Lesson>> getLessons(int year) async {
    final query = selectOnly(tableSurahs)
      ..addColumns([tableSurahs.lesson])
      ..where(tableSurahs.year.equals(year));
    query.groupBy([tableSurahs.lesson]);
    final lessonIds = await query.get();

    final List<Lesson> lessons = [];
    for (var i = 0; i < lessonIds.length; i++) {
      lessons
          .add(await getLesson(lessonIds[i].read(tableSurahs.lesson)!, year));
    }

    return lessons;
  }

  Future<Lesson> getLesson(int lesson, int year) async {
    final query = select(tableSurahs)
      ..where((e) => e.lesson.equals(lesson))
      ..where((e) => e.year.equals(year));
    final results = await query.get();

    return Lesson.fromSurahDto(results);
  }

  Future<List<SurahWord>> getDisabledWords(int lesson, int year) async {
    final selectedSurahQuery = select(tableSurahs)
      ..where((e) => e.year.equals(year))
      ..where((e) => e.lesson.equals(lesson))
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
