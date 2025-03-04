import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:juz_amma_kids/database/tables/table_tracks.dart';

import '../model/track_local_dto.dart';
import './platform/shared.dart' as s;

part 'app_database.g.dart';

@DriftDatabase(tables: [TableTracks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(s.createDatabaseConnection("qurany_app_db"));

  AppDatabase._internal() : super(s.createDatabaseConnection("qurany_app_db"));
  static final AppDatabase instance = AppDatabase._internal();

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 2;

  @override
  // TODO: implement migration
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
    }, onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {}
    }, beforeOpen: (details) async {
      if (kDebugMode) {}
    });
  }
}