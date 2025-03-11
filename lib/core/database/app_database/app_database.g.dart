// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TableTracksTable extends TableTracks
    with TableInfo<$TableTracksTable, TrackLocalDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _soraMeta = const VerificationMeta('sora');
  @override
  late final GeneratedColumn<int> sora = GeneratedColumn<int>(
      'sora', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _memorizedMeta =
      const VerificationMeta('memorized');
  @override
  late final GeneratedColumn<String> memorized = GeneratedColumn<String>(
      'memorized', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<String> read = GeneratedColumn<String>(
      'read', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  @override
  List<GeneratedColumn> get $columns => [id, sora, memorized, read];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_tracks';
  @override
  VerificationContext validateIntegrity(Insertable<TrackLocalDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sora')) {
      context.handle(
          _soraMeta, sora.isAcceptableOrUnknown(data['sora']!, _soraMeta));
    } else if (isInserting) {
      context.missing(_soraMeta);
    }
    if (data.containsKey('memorized')) {
      context.handle(_memorizedMeta,
          memorized.isAcceptableOrUnknown(data['memorized']!, _memorizedMeta));
    }
    if (data.containsKey('read')) {
      context.handle(
          _readMeta, read.isAcceptableOrUnknown(data['read']!, _readMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackLocalDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackLocalDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sora: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sora'])!,
      memorized: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}memorized'])!,
      read: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}read'])!,
    );
  }

  @override
  $TableTracksTable createAlias(String alias) {
    return $TableTracksTable(attachedDatabase, alias);
  }
}

class TableTracksCompanion extends UpdateCompanion<TrackLocalDto> {
  final Value<int> id;
  final Value<int> sora;
  final Value<String> memorized;
  final Value<String> read;
  const TableTracksCompanion({
    this.id = const Value.absent(),
    this.sora = const Value.absent(),
    this.memorized = const Value.absent(),
    this.read = const Value.absent(),
  });
  TableTracksCompanion.insert({
    this.id = const Value.absent(),
    required int sora,
    this.memorized = const Value.absent(),
    this.read = const Value.absent(),
  }) : sora = Value(sora);
  static Insertable<TrackLocalDto> custom({
    Expression<int>? id,
    Expression<int>? sora,
    Expression<String>? memorized,
    Expression<String>? read,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sora != null) 'sora': sora,
      if (memorized != null) 'memorized': memorized,
      if (read != null) 'read': read,
    });
  }

  TableTracksCompanion copyWith(
      {Value<int>? id,
      Value<int>? sora,
      Value<String>? memorized,
      Value<String>? read}) {
    return TableTracksCompanion(
      id: id ?? this.id,
      sora: sora ?? this.sora,
      memorized: memorized ?? this.memorized,
      read: read ?? this.read,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sora.present) {
      map['sora'] = Variable<int>(sora.value);
    }
    if (memorized.present) {
      map['memorized'] = Variable<String>(memorized.value);
    }
    if (read.present) {
      map['read'] = Variable<String>(read.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableTracksCompanion(')
          ..write('id: $id, ')
          ..write('sora: $sora, ')
          ..write('memorized: $memorized, ')
          ..write('read: $read')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TableTracksTable tableTracks = $TableTracksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tableTracks];
}

typedef $$TableTracksTableCreateCompanionBuilder = TableTracksCompanion
    Function({
  Value<int> id,
  required int sora,
  Value<String> memorized,
  Value<String> read,
});
typedef $$TableTracksTableUpdateCompanionBuilder = TableTracksCompanion
    Function({
  Value<int> id,
  Value<int> sora,
  Value<String> memorized,
  Value<String> read,
});

class $$TableTracksTableFilterComposer
    extends Composer<_$AppDatabase, $TableTracksTable> {
  $$TableTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sora => $composableBuilder(
      column: $table.sora, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memorized => $composableBuilder(
      column: $table.memorized, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get read => $composableBuilder(
      column: $table.read, builder: (column) => ColumnFilters(column));
}

class $$TableTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $TableTracksTable> {
  $$TableTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sora => $composableBuilder(
      column: $table.sora, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memorized => $composableBuilder(
      column: $table.memorized, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get read => $composableBuilder(
      column: $table.read, builder: (column) => ColumnOrderings(column));
}

class $$TableTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableTracksTable> {
  $$TableTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sora =>
      $composableBuilder(column: $table.sora, builder: (column) => column);

  GeneratedColumn<String> get memorized =>
      $composableBuilder(column: $table.memorized, builder: (column) => column);

  GeneratedColumn<String> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);
}

class $$TableTracksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TableTracksTable,
    TrackLocalDto,
    $$TableTracksTableFilterComposer,
    $$TableTracksTableOrderingComposer,
    $$TableTracksTableAnnotationComposer,
    $$TableTracksTableCreateCompanionBuilder,
    $$TableTracksTableUpdateCompanionBuilder,
    (
      TrackLocalDto,
      BaseReferences<_$AppDatabase, $TableTracksTable, TrackLocalDto>
    ),
    TrackLocalDto,
    PrefetchHooks Function()> {
  $$TableTracksTableTableManager(_$AppDatabase db, $TableTracksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TableTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sora = const Value.absent(),
            Value<String> memorized = const Value.absent(),
            Value<String> read = const Value.absent(),
          }) =>
              TableTracksCompanion(
            id: id,
            sora: sora,
            memorized: memorized,
            read: read,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sora,
            Value<String> memorized = const Value.absent(),
            Value<String> read = const Value.absent(),
          }) =>
              TableTracksCompanion.insert(
            id: id,
            sora: sora,
            memorized: memorized,
            read: read,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TableTracksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TableTracksTable,
    TrackLocalDto,
    $$TableTracksTableFilterComposer,
    $$TableTracksTableOrderingComposer,
    $$TableTracksTableAnnotationComposer,
    $$TableTracksTableCreateCompanionBuilder,
    $$TableTracksTableUpdateCompanionBuilder,
    (
      TrackLocalDto,
      BaseReferences<_$AppDatabase, $TableTracksTable, TrackLocalDto>
    ),
    TrackLocalDto,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TableTracksTableTableManager get tableTracks =>
      $$TableTracksTableTableManager(_db, _db.tableTracks);
}
