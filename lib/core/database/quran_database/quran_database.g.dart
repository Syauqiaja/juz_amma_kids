// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_database.dart';

// ignore_for_file: type=lint
class $TableSurahsTable extends TableSurahs
    with TableInfo<$TableSurahsTable, SurahLocalDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableSurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
      'page', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _soraMeta = const VerificationMeta('sora');
  @override
  late final GeneratedColumn<int> sora = GeneratedColumn<int>(
      'sora', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ayaMeta = const VerificationMeta('aya');
  @override
  late final GeneratedColumn<int> aya = GeneratedColumn<int>(
      'aya', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lineMeta = const VerificationMeta('line');
  @override
  late final GeneratedColumn<int> line = GeneratedColumn<int>(
      'line', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lessonMeta = const VerificationMeta('lesson');
  @override
  late final GeneratedColumn<int> lesson = GeneratedColumn<int>(
      'lesson', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, page, sora, aya, line, year, lesson, word];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran_words';
  @override
  VerificationContext validateIntegrity(Insertable<SurahLocalDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('sora')) {
      context.handle(
          _soraMeta, sora.isAcceptableOrUnknown(data['sora']!, _soraMeta));
    } else if (isInserting) {
      context.missing(_soraMeta);
    }
    if (data.containsKey('aya')) {
      context.handle(
          _ayaMeta, aya.isAcceptableOrUnknown(data['aya']!, _ayaMeta));
    } else if (isInserting) {
      context.missing(_ayaMeta);
    }
    if (data.containsKey('line')) {
      context.handle(
          _lineMeta, line.isAcceptableOrUnknown(data['line']!, _lineMeta));
    } else if (isInserting) {
      context.missing(_lineMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('lesson')) {
      context.handle(_lessonMeta,
          lesson.isAcceptableOrUnknown(data['lesson']!, _lessonMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurahLocalDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurahLocalDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      page: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page'])!,
      sora: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sora'])!,
      aya: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}aya'])!,
      line: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      lesson: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lesson']),
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
    );
  }

  @override
  $TableSurahsTable createAlias(String alias) {
    return $TableSurahsTable(attachedDatabase, alias);
  }
}

class TableSurahsCompanion extends UpdateCompanion<SurahLocalDto> {
  final Value<int> id;
  final Value<int> page;
  final Value<int> sora;
  final Value<int> aya;
  final Value<int> line;
  final Value<int> year;
  final Value<int?> lesson;
  final Value<String> word;
  const TableSurahsCompanion({
    this.id = const Value.absent(),
    this.page = const Value.absent(),
    this.sora = const Value.absent(),
    this.aya = const Value.absent(),
    this.line = const Value.absent(),
    this.year = const Value.absent(),
    this.lesson = const Value.absent(),
    this.word = const Value.absent(),
  });
  TableSurahsCompanion.insert({
    this.id = const Value.absent(),
    required int page,
    required int sora,
    required int aya,
    required int line,
    required int year,
    this.lesson = const Value.absent(),
    required String word,
  })  : page = Value(page),
        sora = Value(sora),
        aya = Value(aya),
        line = Value(line),
        year = Value(year),
        word = Value(word);
  static Insertable<SurahLocalDto> custom({
    Expression<int>? id,
    Expression<int>? page,
    Expression<int>? sora,
    Expression<int>? aya,
    Expression<int>? line,
    Expression<int>? year,
    Expression<int>? lesson,
    Expression<String>? word,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (page != null) 'page': page,
      if (sora != null) 'sora': sora,
      if (aya != null) 'aya': aya,
      if (line != null) 'line': line,
      if (year != null) 'year': year,
      if (lesson != null) 'lesson': lesson,
      if (word != null) 'word': word,
    });
  }

  TableSurahsCompanion copyWith(
      {Value<int>? id,
      Value<int>? page,
      Value<int>? sora,
      Value<int>? aya,
      Value<int>? line,
      Value<int>? year,
      Value<int?>? lesson,
      Value<String>? word}) {
    return TableSurahsCompanion(
      id: id ?? this.id,
      page: page ?? this.page,
      sora: sora ?? this.sora,
      aya: aya ?? this.aya,
      line: line ?? this.line,
      year: year ?? this.year,
      lesson: lesson ?? this.lesson,
      word: word ?? this.word,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (sora.present) {
      map['sora'] = Variable<int>(sora.value);
    }
    if (aya.present) {
      map['aya'] = Variable<int>(aya.value);
    }
    if (line.present) {
      map['line'] = Variable<int>(line.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (lesson.present) {
      map['lesson'] = Variable<int>(lesson.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableSurahsCompanion(')
          ..write('id: $id, ')
          ..write('page: $page, ')
          ..write('sora: $sora, ')
          ..write('aya: $aya, ')
          ..write('line: $line, ')
          ..write('year: $year, ')
          ..write('lesson: $lesson, ')
          ..write('word: $word')
          ..write(')'))
        .toString();
  }
}

abstract class _$QuranDatabase extends GeneratedDatabase {
  _$QuranDatabase(QueryExecutor e) : super(e);
  $QuranDatabaseManager get managers => $QuranDatabaseManager(this);
  late final $TableSurahsTable tableSurahs = $TableSurahsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tableSurahs];
}

typedef $$TableSurahsTableCreateCompanionBuilder = TableSurahsCompanion
    Function({
  Value<int> id,
  required int page,
  required int sora,
  required int aya,
  required int line,
  required int year,
  Value<int?> lesson,
  required String word,
});
typedef $$TableSurahsTableUpdateCompanionBuilder = TableSurahsCompanion
    Function({
  Value<int> id,
  Value<int> page,
  Value<int> sora,
  Value<int> aya,
  Value<int> line,
  Value<int> year,
  Value<int?> lesson,
  Value<String> word,
});

class $$TableSurahsTableFilterComposer
    extends Composer<_$QuranDatabase, $TableSurahsTable> {
  $$TableSurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sora => $composableBuilder(
      column: $table.sora, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aya => $composableBuilder(
      column: $table.aya, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get line => $composableBuilder(
      column: $table.line, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lesson => $composableBuilder(
      column: $table.lesson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));
}

class $$TableSurahsTableOrderingComposer
    extends Composer<_$QuranDatabase, $TableSurahsTable> {
  $$TableSurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sora => $composableBuilder(
      column: $table.sora, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aya => $composableBuilder(
      column: $table.aya, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get line => $composableBuilder(
      column: $table.line, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lesson => $composableBuilder(
      column: $table.lesson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));
}

class $$TableSurahsTableAnnotationComposer
    extends Composer<_$QuranDatabase, $TableSurahsTable> {
  $$TableSurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<int> get sora =>
      $composableBuilder(column: $table.sora, builder: (column) => column);

  GeneratedColumn<int> get aya =>
      $composableBuilder(column: $table.aya, builder: (column) => column);

  GeneratedColumn<int> get line =>
      $composableBuilder(column: $table.line, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get lesson =>
      $composableBuilder(column: $table.lesson, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);
}

class $$TableSurahsTableTableManager extends RootTableManager<
    _$QuranDatabase,
    $TableSurahsTable,
    SurahLocalDto,
    $$TableSurahsTableFilterComposer,
    $$TableSurahsTableOrderingComposer,
    $$TableSurahsTableAnnotationComposer,
    $$TableSurahsTableCreateCompanionBuilder,
    $$TableSurahsTableUpdateCompanionBuilder,
    (
      SurahLocalDto,
      BaseReferences<_$QuranDatabase, $TableSurahsTable, SurahLocalDto>
    ),
    SurahLocalDto,
    PrefetchHooks Function()> {
  $$TableSurahsTableTableManager(_$QuranDatabase db, $TableSurahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableSurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableSurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TableSurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> page = const Value.absent(),
            Value<int> sora = const Value.absent(),
            Value<int> aya = const Value.absent(),
            Value<int> line = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int?> lesson = const Value.absent(),
            Value<String> word = const Value.absent(),
          }) =>
              TableSurahsCompanion(
            id: id,
            page: page,
            sora: sora,
            aya: aya,
            line: line,
            year: year,
            lesson: lesson,
            word: word,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int page,
            required int sora,
            required int aya,
            required int line,
            required int year,
            Value<int?> lesson = const Value.absent(),
            required String word,
          }) =>
              TableSurahsCompanion.insert(
            id: id,
            page: page,
            sora: sora,
            aya: aya,
            line: line,
            year: year,
            lesson: lesson,
            word: word,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TableSurahsTableProcessedTableManager = ProcessedTableManager<
    _$QuranDatabase,
    $TableSurahsTable,
    SurahLocalDto,
    $$TableSurahsTableFilterComposer,
    $$TableSurahsTableOrderingComposer,
    $$TableSurahsTableAnnotationComposer,
    $$TableSurahsTableCreateCompanionBuilder,
    $$TableSurahsTableUpdateCompanionBuilder,
    (
      SurahLocalDto,
      BaseReferences<_$QuranDatabase, $TableSurahsTable, SurahLocalDto>
    ),
    SurahLocalDto,
    PrefetchHooks Function()>;

class $QuranDatabaseManager {
  final _$QuranDatabase _db;
  $QuranDatabaseManager(this._db);
  $$TableSurahsTableTableManager get tableSurahs =>
      $$TableSurahsTableTableManager(_db, _db.tableSurahs);
}
