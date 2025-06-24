import 'package:equatable/equatable.dart';

class SurahWord extends Equatable{
  final int id;
  final int page;
  final int sora;
  final int aya;
  final int line;
  final String word;

  const SurahWord({required this.id, required this.page, required this.sora, required this.aya, required this.line, required this.word});

  // Factory constructor to create Surah from JSON
  factory SurahWord.fromJson(Map<String, dynamic> json) {
    return SurahWord(
      id: json['id'] as int,
      page: json['page'] as int,
      sora: json['sora'] as int,
      aya: json['aya'] as int,
      line: json['line'] as int,
      word: json['word'] as String,
    );
  }

  @override
  List<Object?> get props => [id, page, sora, aya, line, word];
}