import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:juz_amma_kids/core/model/memorization_model.dart';

import '../app_database/app_database.dart';

class TrackLocalDto implements Insertable<TrackLocalDto> {
  final int? id;
  final int sora;
  final String memorized;
  final String read;

  TrackLocalDto({
    this.id,
    required this.sora,
    required this.memorized,
    required this.read,
  });

  MemorizationModel toDomain() {
    return MemorizationModel(
      id: id!,
      memorized: (jsonDecode(memorized) as Map<String, dynamic>).map((key, value) => MapEntry(int.parse(key), value)),
      read: (jsonDecode(read)  as Map<String, dynamic>).map((key, value) => MapEntry(int.parse(key), value)),
      sora: sora,
    );
  }

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return TableTracksCompanion(
      id: id != null ?  Value(id!) : const Value.absent(),
      sora: Value(sora),
      memorized: Value(memorized),
      read: Value(read),
    ).toColumns(nullToAbsent);
  }

  TrackLocalDto copyWith({
    int? id,
    int? sora,
    String? memorized,
    String? read,
  }) {
    return TrackLocalDto(
      id: id ?? this.id,
      sora: sora ?? this.sora,
      memorized: memorized ?? this.memorized,
      read: read ?? this.read,
    );
  }
}
