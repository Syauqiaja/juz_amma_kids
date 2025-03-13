import 'package:juz_amma_kids/core/database/app_database/app_database.dart';
import 'package:juz_amma_kids/core/database/queries/surah_dao.dart';
import 'package:juz_amma_kids/core/database/queries/track_dao.dart';
import 'package:juz_amma_kids/core/database/quran_database/quran_database.dart';
import 'package:juz_amma_kids/core/model/memorization_model.dart';
import 'package:juz_amma_kids/core/model/surah_word.dart';
import 'package:juz_amma_kids/core/services/sora_names_const.dart';

import '../database/model/surah_local_dto.dart';

class Surah {
  final int startAya;
  final int endAya;
  final int soraIndex;
  final int totalAya;
  final String title;
  final String titleArabic;
  final String imageAsset;
  final List<SurahWord> words;
  final MemorizationModel? memorizationModel;

  Surah({
    required this.startAya,
    required this.endAya,
    required this.soraIndex,
    required this.words,
    required this.totalAya,
    required this.title,
    required this.titleArabic,
    required this.imageAsset,
    this.memorizationModel,
  });

  factory Surah.fromSurahDto(List<SurahLocalDto> surahDto, MemorizationModel? memorization) {
    final id = surahDto.first.sora;
    return Surah(
      startAya: surahDto.first.aya,
      endAya: surahDto.last.aya,
      soraIndex: id,
      totalAya: surahDto.last.aya,
      title: SoraNamesConstant.latinSoraNames[id - 1],
      titleArabic: SoraNamesConstant.cSoraNames[id - 1],
      imageAsset: "assets/titles/$id.svg",
      words: surahDto.map((e) => e.toDomain()).toList(),
      memorizationModel: memorization
    );
  }

  static Future<Surah> getCompleteSurah(int id) async {
    final SurahDao surahDao = SurahDao(QuranDatabase.instance);
    final TrackDao trackDao = TrackDao(AppDatabase.instance);

    final surah = await surahDao.getSurah(id);
    final memorizationModel = await trackDao.getTrackSurah(surahIndex: id, totalAya: surah.totalAya);

    return Surah(
      startAya: surah.startAya,
      endAya: surah.endAya,
      soraIndex: surah.soraIndex,
      words: surah.words,
      totalAya: surah.totalAya,
      title: surah.title,
      titleArabic: surah.title,
      imageAsset: surah.imageAsset,
      memorizationModel: memorizationModel,
    );
  }
}
