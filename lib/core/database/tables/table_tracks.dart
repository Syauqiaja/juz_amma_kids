import 'package:drift/drift.dart';
import 'package:juz_amma_kids/database/model/track_local_dto.dart';

@UseRowClass(TrackLocalDto)
class TableTracks extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lesson => integer()();
  IntColumn get year => integer()();
  IntColumn get sora => integer()();
  TextColumn get memorized => text().withDefault(const Constant('{}'))();
  TextColumn get read => text().withDefault(const Constant('{}'))();
}