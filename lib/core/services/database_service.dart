import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/core/model/surah_word.dart';
import 'package:juz_amma_kids/core/database/app_database/app_database.dart';
import 'package:juz_amma_kids/core/database/queries/surah_dao.dart';
import 'package:juz_amma_kids/core/database/queries/track_dao.dart';
import 'package:juz_amma_kids/core/database/quran_database/quran_database.dart';

class DatabaseService {
  final quranTable = 'quran';
  final trackingTable = 'read_tracks';
  final userTable = 'users';

  final _surahDao = SurahDao(QuranDatabase.instance);
  final _trackDao = TrackDao(AppDatabase.instance);

  Future<List<SurahWord>> getAll() async {
    final result = await _surahDao.getAllSurahs();
    return result.map((e) => e.toDomain()).toList();
  }

  Future<List<SurahWord>> searchBySurahIndex(int soraIndex) async {
    final result = await _surahDao.searchBySurahIndex(soraIndex);
    return result.map((e) => e.toDomain()).toList();
  }

  Future<int> getTotalAyaOfSurah(int soraIndex) async {
    return await _surahDao.getTotalAyaOfSurah(soraIndex);
  }

  Future<List<SurahWord>> getDisabledWords(int surah) async {
    return await _surahDao.getDisabledWords(surah);
  }

  Future<List<Surah>> getSurahs() async {
    return await _surahDao.getSurahs();
  }
  Future<Surah> getSurah(int soraIndex) async {
    return await _surahDao.getSurah(soraIndex);
  }

  Future<Map<int, bool>> getReadAya(
      {required Surah surah,}) async {
    return _trackDao.getTrackAya(
      surah: surah,
      trackType: TrackType.read,
    );
  }

  Future<Map<int, bool>> getReadAyaByUserId(
      {required Surah surah}) async {
    return _trackDao.getTrackAya(
      surah: surah,
      trackType: TrackType.read,
    );
  }

  Future<Map<int, bool>> insertReadAya(
      {required Surah surah,
      required int ayaIndex,
      required bool value,}) async {
    return _trackDao.insertTrackAya(
      surah: surah,
      ayaIndex: ayaIndex,
      value: value,
      trackType: TrackType.read,
    );
  }

  Future<Map<int, bool>> getMemorizedAya(
      {required Surah surah}) async {
    return _trackDao.getTrackAya(
      surah: surah,
      trackType: TrackType.memorization,
    );
  }

  Future<Map<int, bool>> insertMemorizedAya(
      {required Surah surah,
      required int ayaIndex,
      required bool value,}) async {
    return _trackDao.insertTrackAya(
      surah: surah,
      ayaIndex: ayaIndex,
      value: value,
      trackType: TrackType.memorization,
    );
  }
}
