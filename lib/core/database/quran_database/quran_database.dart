import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:juz_amma_kids/database/tables/table_surahs.dart';

import '../model/surah_local_dto.dart';
import './platform/shared.dart' as s;

part 'quran_database.g.dart';

@DriftDatabase(tables: [TableSurahs])
class QuranDatabase extends _$QuranDatabase {
  QuranDatabase() : super(s.createDatabaseConnection("qurany_quran_db"));

  QuranDatabase._internal() : super(s.createDatabaseConnection("qurany_quran_db"));
  static final QuranDatabase instance = QuranDatabase._internal();

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;

  @override
  // TODO: implement migration
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {}
      },
      beforeOpen: (details) async {
        if (kDebugMode) {}
      },
    );
  }
}