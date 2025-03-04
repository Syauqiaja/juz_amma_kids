import 'dart:convert';
import 'package:juz_amma_kids/core/model/lesson.dart';
import 'package:juz_amma_kids/core/model/memorization_model.dart';
import 'package:juz_amma_kids/core/model/surah.dart';
import 'package:juz_amma_kids/database/app_database/app_database.dart';
import 'package:juz_amma_kids/database/queries/surah_dao.dart';
import 'package:juz_amma_kids/database/queries/track_dao.dart';
import 'package:juz_amma_kids/database/quran_database/quran_database.dart';
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

  Future<int> getTotalAyaOfLesson(int lessonIndex, int year) async {
    return await _surahDao.getTotalAyaOfLesson(lessonIndex, year);
  }

  Future<List<int>> getAyahsOfLesson(int lessonIndex, int year) async {
    return await _surahDao.getAyahsOfLesson(lessonIndex, year);
  }

  Future<Map<int, List<Lesson>>> getLessonsOfYears(List<int> years) async {
    return _surahDao.getLessonsOfYears(years);
  }

  Future<List<Lesson>> getLessons(int year) async {
    return _surahDao.getLessons(year);
  }

  Future<Lesson?> getLesson(int lesson, int year) async {
    return _surahDao.getLesson(lesson, year);
  }

  Future<List<SurahWord>> getDisabledWords(int lesson, int year) async {
    return _surahDao.getDisabledWords(lesson, year);
  }

  Future<List<Map<String, int>>> queryLessonOfYear(int year) async {
    return await _surahDao.queryLessonOfYear(year);
  }

  Future<Map<int, bool>> getReadAya(
      {required Lesson lesson,}) async {
    return _trackDao.getTrackAya(
      lesson: lesson,
      trackType: TrackType.read,
    );
  }

  Future<Map<int, bool>> getReadAyaByUserId(
      {required Lesson lesson, required int userId}) async {
    return _trackDao.getTrackAyaByUserId(
      lesson: lesson,
      trackType: TrackType.read,
    );
  }

  Future<Map<int, bool>> insertReadAya(
      {required Lesson lesson,
      required int ayaIndex,
      required bool value,}) async {
    return _trackDao.insertTrackAya(
      lesson: lesson,
      ayaIndex: ayaIndex,
      value: value,
      trackType: TrackType.read,
    );
  }

  Future<Map<int, bool>> getMemorizedAya(
      {required Lesson lesson}) async {
    return _trackDao.getTrackAya(
      lesson: lesson,
      trackType: TrackType.memorization,
    );
  }

  Future<Map<int, bool>> getMemorizationAyaByUserId(
      {required Lesson lesson, required int userId}) async {
    return _trackDao.getTrackAyaByUserId(
      lesson: lesson,
      trackType: TrackType.memorization,
    );
  }

  Future<Map<int, bool>> insertMemorizedAya(
      {required Lesson lesson,
      required int ayaIndex,
      required bool value,}) async {
    return _trackDao.insertTrackAya(
      lesson: lesson,
      ayaIndex: ayaIndex,
      value: value,
      trackType: TrackType.memorization,
    );
  }

  Future<List<MemorizationModel>> getMemorizationOfUser(List<int> years) async {
    return _trackDao.getMemorizationOfUser(years);
  }
}
