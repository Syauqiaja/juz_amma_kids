import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:juz_amma_kids/core/database/model/track_local_dto.dart';

class MemorizationModel {
  final int id;
  final int sora;
  final Map<int, bool> memorized;
  final Map<int, bool> read;

  MemorizationModel(
      {required this.id,
      required this.memorized,
      required this.read,
      required this.sora});

  // Factory constructor to create an instance from a JSON map
  factory MemorizationModel.fromJson(Map<String, dynamic> json) {
    return MemorizationModel(
      id: json['id'],
      sora: json['sora'],
      memorized: (json['memorized'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value as bool)),
      read: (json['read'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value as bool)),
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'memorized': memorized, 'read': read, 'sora': sora};
  }

  double memorizedPercentage() {
    if (memorized.isEmpty) return 0;

    final length = memorized.values.length;
    final total = memorized.values
        .fold(0.0, (prev, value) => prev + (value == true ? 1 : 0));
    return total / length;
  }

  double readPercentage() {
    if (read.isEmpty) return 0;

    final length = read.values.length;
    final total =
        read.values.fold(0.0, (prev, value) => prev + (value == true ? 1 : 0));
    return total / length;
  }

  TrackLocalDto toData() {
    return TrackLocalDto(
      sora: sora,
      memorized: jsonEncode(memorized.map((key, value)=>MapEntry(key.toString(), value))),
      read: jsonEncode(read.map((key, value)=>MapEntry(key.toString(), value))),
    );
  }
}

class MemorizedVerse extends Equatable {
  final String status;
  final String transcription;
  final String verseNumber;
  final List<MemorizedWord> words;

  MemorizedVerse({
    required this.status,
    required this.transcription,
    required this.verseNumber,
    required this.words,
  });

  // fromJson factory constructor
  factory MemorizedVerse.fromJson(Map<String, dynamic> json) {
    return MemorizedVerse(
      status: json['status'],
      transcription: json['transcription'],
      verseNumber: json['verse_number'],
      words: (json['words'] as List)
          .map((e) => MemorizedWord.fromJson(e))
          .toList(),
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'transcription': transcription,
      'verse_number': verseNumber,
      'words': words.map((e) => e.toJson()).toList(),
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [verseNumber];
}

class MemorizedWord {
  final int index;
  final String status;
  final String word;

  MemorizedWord({
    required this.index,
    required this.status,
    required this.word,
  });

  // fromJson factory constructor
  factory MemorizedWord.fromJson(Map<String, dynamic> json) {
    return MemorizedWord(
      index: json['index'],
      status: json['status'],
      word: json['word'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'status': status,
      'word': word,
    };
  }
}
