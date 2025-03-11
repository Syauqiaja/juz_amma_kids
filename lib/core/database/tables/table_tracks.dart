import 'package:drift/drift.dart';
import 'package:juz_amma_kids/core/database/model/track_local_dto.dart';

@UseRowClass(TrackLocalDto)
class TableTracks extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sora => integer()();
  TextColumn get memorized => text().withDefault(const Constant('{}'))();
  TextColumn get read => text().withDefault(const Constant('{}'))();
}