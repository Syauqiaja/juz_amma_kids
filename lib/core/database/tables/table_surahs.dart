
import 'package:drift/drift.dart';
import 'package:juz_amma_kids/database/model/surah_local_dto.dart';

@UseRowClass(SurahLocalDto)
class TableSurahs extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get page => integer()();
  IntColumn get sora => integer()();
  IntColumn get aya => integer()();
  IntColumn get line => integer()();
  IntColumn get year => integer()();
  IntColumn get lesson => integer().nullable()();
  TextColumn get word => text()();

  @override
  // TODO: implement tableName
  String? get tableName => 'quran_words';
}