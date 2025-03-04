import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:juz_amma_kids/core/model/memorization_model.dart';

import '../app_database/app_database.dart';

class TrackLocalDto implements Insertable<TrackLocalDto> {
  final int? id;
  final int lesson;
  final int year;
  final int sora;
  final String memorized;
  final String read;

  TrackLocalDto({
    this.id,
    required this.lesson,
    required this.year,
    required this.sora,
    required this.memorized,
    required this.read,
  });

  MemorizationModel toDomain() {
    return MemorizationModel(
      year: year,
      lesson: lesson,
      memorized: jsonDecode(memorized),
      read: jsonDecode(read),
      sora: sora,
    );
  }

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return TableTracksCompanion(
      id: id != null ?  Value(id!) : const Value.absent(),
      lesson: Value(lesson),
      year: Value(year),
      sora: Value(sora),
      memorized: Value(memorized),
      read: Value(read),
    ).toColumns(nullToAbsent);
  }

  TrackLocalDto copyWith({
    int? id,
    int? lesson,
    int? year,
    int? sora,
    String? memorized,
    String? read,
  }) {
    return TrackLocalDto(
      id: id ?? this.id,
      lesson: lesson ?? this.lesson,
      year: year ?? this.year,
      sora: sora ?? this.sora,
      memorized: memorized ?? this.memorized,
      read: read ?? this.read,
    );
  }
}
