import 'package:juz_amma_kids/core/model/surah.dart';

import '../../database/model/surah_local_dto.dart';

class Lesson {
  final int startAya;
  final int endAya;
  final int soraIndex;
  final int lesson;
  final int year;
  final List<SurahWord> words;

  Lesson({
    required this.startAya,
    required this.endAya,
    required this.soraIndex,
    required this.lesson,
    required this.year,
    required this.words,
  });

  // Factory constructor to create Lesson from JSON
  factory Lesson.fromJson(List<Map<String, dynamic>> json) {
    List<SurahWord> wordsList = json
        .map((wordJson) => SurahWord.fromJson(wordJson as Map<String, dynamic>))
        .toList(); // Convert each word JSON to SurahWord

    return Lesson(
      startAya: json.first['aya'] as int,
      endAya: json.last['aya'] as int,
      soraIndex: json.first['sora'] as int,
      lesson: json.first['lesson'] as int,
      year: json.first['year'] as int,
      words: wordsList, // Assign the parsed words list
    );
  }

  factory Lesson.fromSurahDto(List<SurahLocalDto> surahDto){
    return Lesson(
      startAya: surahDto.first.aya,
      endAya: surahDto.last.aya,
      soraIndex: surahDto.first.sora,
      lesson: surahDto.first.lesson ?? 0,
      year: surahDto.first.year,
      words: surahDto.map((e) => e.toDomain()).toList(),
    );
  }
}
