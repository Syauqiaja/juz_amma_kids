import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:juz_amma_kids/core/database/app_database/app_database.dart';
import 'package:juz_amma_kids/core/database/model/track_local_dto.dart';
import 'package:juz_amma_kids/core/database/queries/surah_dao.dart';
import 'package:juz_amma_kids/core/database/quran_database/quran_database.dart';
import 'package:juz_amma_kids/core/database/tables/table_tracks.dart';
import 'package:juz_amma_kids/core/model/lesson.dart';

import '../../model/memorization_model.dart';

part 'track_dao.g.dart';

@DriftAccessor(tables: [TableTracks])
class TrackDao extends DatabaseAccessor<AppDatabase> with _$TrackDaoMixin {
  TrackDao(this.db) : super(db);

  final AppDatabase db;
  final SurahDao _surahDao = SurahDao(QuranDatabase.instance);

  Future<Map<int, bool>> getTrackAya({
    required Surah surah,
    required TrackType trackType,
  }) async {
    final columnType =
        trackType == TrackType.read ? tableTracks.read : tableTracks.memorized;
    final query = selectOnly(tableTracks)
      ..addColumns([columnType])
      ..where(tableTracks.sora.equals(surah.soraIndex));

    final result = await query.get();
    if (result.isEmpty) return {};

    final Map<String, dynamic> trackedAyahs =
        jsonDecode(result.first.read(columnType)!);
    return trackedAyahs
        .map((key, value) => MapEntry(int.parse(key), value as bool));
  }

  Future<Map<int, bool>> insertTrackAya({
    required Surah surah,
    required int ayaIndex,
    required bool value,
    required TrackType trackType,
  }) async {
    final query = select(tableTracks)
      ..where((e) => e.sora.equals(surah.soraIndex));
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
      final totalAya =
          await _surahDao.getTotalAyaOfSurah(surah.soraIndex);
      final Map<String, bool> currentValue = {
        for (var element in List.generate(totalAya, (i) => i + 1)) element.toString(): false
      };
      currentValue[ayaIndex.toString()] = value;
      into(tableTracks).insert(TrackLocalDto(
        id: null,
        sora: surah.soraIndex,
        memorized: trackType == TrackType.memorization
            ? jsonEncode(currentValue)
            : '{}',
        read: trackType == TrackType.read ? jsonEncode(currentValue) : '{}',
      ));
    }

    return getTrackAya(
        surah: surah, trackType: trackType);
  }
}

enum TrackType {
  read,
  memorization,
}
