import 'package:juz_amma_kids/core/model/surah_word.dart';
import 'package:juz_amma_kids/core/services/sora_names_const.dart';

import '../database/model/surah_local_dto.dart';

class Surah {
  final int startAya;
  final int endAya;
  final int soraIndex;
  final int totalAya;
  final String title;
  final String imageAsset;
  final List<SurahWord> words;

  Surah({
    required this.startAya,
    required this.endAya,
    required this.soraIndex,
    required this.words,
    required this.totalAya,
    required this.title,
    required this.imageAsset,
  });

  factory Surah.fromSurahDto(List<SurahLocalDto> surahDto){
    final id = surahDto.first.sora;
    return Surah(
      startAya: surahDto.first.aya,
      endAya: surahDto.last.aya,
      soraIndex: id,
      totalAya: surahDto.last.aya,
      title: SoraNamesConstant.latinSoraNames[id - 1],
      imageAsset: "assets/titles/$id.svg",
      words: surahDto.map((e) => e.toDomain()).toList(),
    );
  }
}
