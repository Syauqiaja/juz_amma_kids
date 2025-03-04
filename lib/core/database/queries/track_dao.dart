import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:juz_amma_kids/database/app_database/app_database.dart';
import 'package:juz_amma_kids/database/model/track_local_dto.dart';
import 'package:juz_amma_kids/database/queries/surah_dao.dart';
import 'package:juz_amma_kids/database/quran_database/quran_database.dart';
import 'package:juz_amma_kids/database/tables/table_tracks.dart';

import '../../core/model/lesson.dart';
import '../../core/model/memorization_model.dart';

part 'track_dao.g.dart';

@DriftAccessor(tables: [TableTracks])
class TrackDao extends DatabaseAccessor<AppDatabase> with _$TrackDaoMixin {
  TrackDao(this.db) : super(db);

  final AppDatabase db;
  final SurahDao _surahDao = SurahDao(QuranDatabase.instance);

  Future<Map<int, bool>> getTrackAya({
    required Lesson lesson,
    required TrackType trackType,
  }) async {

    return await getTrackAyaByUserId(
        lesson: lesson, trackType: trackType);
  }

  Future<Map<int, bool>> getTrackAyaByUserId({
    required Lesson lesson,
    required TrackType trackType,
  }) async {
    final columnType =
        trackType == TrackType.read ? tableTracks.read : tableTracks.memorized;
    final query = selectOnly(tableTracks)
      ..addColumns([columnType])
      ..where(tableTracks.lesson.equals(lesson.lesson))
      ..where(tableTracks.year.equals(lesson.year));

    final result = await query.get();
    if (result.isEmpty) return {};

    final Map<String, dynamic> trackedAyahs =
        jsonDecode(result.first.read(columnType)!);
    return trackedAyahs
        .map((key, value) => MapEntry(int.parse(key), value as bool));
  }

  Future<Map<int, bool>> insertTrackAya({
    required Lesson lesson,
    required int ayaIndex,
    required bool value,
    required TrackType trackType,
  }) async {
    final query = select(tableTracks)
      ..where((e) => e.lesson.equals(lesson.lesson))
      ..where((e) => e.year.equals(lesson.year));
    final result = await query.get();

    if (result.isNotEmpty) {
      final Map<String, dynamic> currentValue = jsonDecode(
        trackType == TrackType.read
            ? result.first.read
            : result.first.memorized,
      );
      currentValue[ayaIndex.toString()] = value;
      if (trackType == TrackType.read) {
        await db.update(tableTracks)
            .replace(result.first.copyWith(read: jsonEncode(currentValue)));
      } else {
        await db.update(tableTracks).replace(
            result.first.copyWith(memorized: jsonEncode(currentValue)));
      }
    } else {
      final ayahs =
          await _surahDao.getAyahsOfLesson(lesson.lesson, lesson.year);
      final Map<String, bool> currentValue = {
        for (var element in ayahs) element.toString(): false
      };
      currentValue[ayaIndex.toString()] = value;
      into(tableTracks).insert(TrackLocalDto(
        id: null,
        lesson: lesson.lesson,
        year: lesson.year,
        sora: lesson.soraIndex,
        memorized: trackType == TrackType.memorization
            ? jsonEncode(currentValue)
            : '{}',
        read: trackType == TrackType.read ? jsonEncode(currentValue) : '{}',
      ));
    }

    return getTrackAyaByUserId(
        lesson: lesson, trackType: trackType);
  }

  Future<List<MemorizationModel>> getMemorizationOfUser(
    List<int> years,
  ) async {
    final List<MemorizationModel> result = [];
    for (int year in years) {
      final quranRows = await _surahDao.queryLessonOfYear(year);
      if (quranRows.isEmpty) break;

      final lessons = quranRows.map((e) => e['lesson'] as int).toList();

      for (int lesson in lessons) {
        final rows = select(tableTracks)
          ..where((e) => e.year.equals(year))
          ..where((e) => e.lesson.equals(lesson));
        final queryResult = await rows.get();

        if (queryResult.isEmpty) {
          int sora =
              quranRows.firstWhere((e) => e['lesson'] == lesson)['sora'] as int;
          result.add(MemorizationModel(
              year: year,
              lesson: lesson,
              memorized: {1: false},
              read: {1: false},
              sora: sora));
        } else {
          final memorized = queryResult.first.memorized != '{}'
              ? (jsonDecode(queryResult.first.memorized)
                      as Map<String, dynamic>)
                  .map((key, value) => MapEntry(int.parse(key), value as bool))
              : {1: false};
          final read = queryResult.first.read != '{}'
              ? (jsonDecode(queryResult.first.read) as Map<String, dynamic>)
                  .map((key, value) => MapEntry(int.parse(key), value as bool))
              : {1: false};

          result.add(MemorizationModel(
              year: year,
              lesson: lesson,
              memorized: memorized,
              read: read,
              sora: queryResult.first.sora,
            ),
          );
        }
      }
    }
    return result;
  }
}

enum TrackType {
  read,
  memorization,
}
