// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TableUsersTable extends TableUsers
    with TableInfo<$TableUsersTable, UserLocalDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _photoUrlMeta =
      const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
      'photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, username, name, role, photoUrl, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_users';
  @override
  VerificationContext validateIntegrity(Insertable<UserLocalDto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(_photoUrlMeta,
          photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserLocalDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserLocalDto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      photoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_url']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TableUsersTable createAlias(String alias) {
    return $TableUsersTable(attachedDatabase, alias);
  }
}

class TableUsersCompanion extends UpdateCompanion<UserLocalDto> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> name;
  final Value<String> role;
  final Value<String?> photoUrl;
  final Value<String> updatedAt;
  const TableUsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TableUsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String name,
    required String role,
    this.photoUrl = const Value.absent(),
    required String updatedAt,
  })  : username = Value(username),
        name = Value(name),
        role = Value(role),
        updatedAt = Value(updatedAt);
  static Insertable<UserLocalDto> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? photoUrl,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TableUsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? name,
      Value<String>? role,
      Value<String?>? photoUrl,
      Value<String>? updatedAt}) {
    return TableUsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableUsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lessonMeta = const VerificationMeta('lesson');
  @override
  late final GeneratedColumn<int> lesson = GeneratedColumn<int>(
      'lesson', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
  List<GeneratedColumn> get $columns =>
      [id, userId, lesson, year, sora, memorized, read];
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
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('lesson')) {
      context.handle(_lessonMeta,
          lesson.isAcceptableOrUnknown(data['lesson']!, _lessonMeta));
    } else if (isInserting) {
      context.missing(_lessonMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
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
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      lesson: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lesson'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
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
  final Value<int> userId;
  final Value<int> lesson;
  final Value<int> year;
  final Value<int> sora;
  final Value<String> memorized;
  final Value<String> read;
  const TableTracksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.lesson = const Value.absent(),
    this.year = const Value.absent(),
    this.sora = const Value.absent(),
    this.memorized = const Value.absent(),
    this.read = const Value.absent(),
  });
  TableTracksCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int lesson,
    required int year,
    required int sora,
    this.memorized = const Value.absent(),
    this.read = const Value.absent(),
  })  : userId = Value(userId),
        lesson = Value(lesson),
        year = Value(year),
        sora = Value(sora);
  static Insertable<TrackLocalDto> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? lesson,
    Expression<int>? year,
    Expression<int>? sora,
    Expression<String>? memorized,
    Expression<String>? read,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (lesson != null) 'lesson': lesson,
      if (year != null) 'year': year,
      if (sora != null) 'sora': sora,
      if (memorized != null) 'memorized': memorized,
      if (read != null) 'read': read,
    });
  }

  TableTracksCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? lesson,
      Value<int>? year,
      Value<int>? sora,
      Value<String>? memorized,
      Value<String>? read}) {
    return TableTracksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lesson: lesson ?? this.lesson,
      year: year ?? this.year,
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
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (lesson.present) {
      map['lesson'] = Variable<int>(lesson.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
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
          ..write('userId: $userId, ')
          ..write('lesson: $lesson, ')
          ..write('year: $year, ')
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
  late final $TableUsersTable tableUsers = $TableUsersTable(this);
  late final $TableTracksTable tableTracks = $TableTracksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tableUsers, tableTracks];
}

typedef $$TableUsersTableCreateCompanionBuilder = TableUsersCompanion Function({
  Value<int> id,
  required String username,
  required String name,
  required String role,
  Value<String?> photoUrl,
  required String updatedAt,
});
typedef $$TableUsersTableUpdateCompanionBuilder = TableUsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> name,
  Value<String> role,
  Value<String?> photoUrl,
  Value<String> updatedAt,
});

class $$TableUsersTableFilterComposer
    extends Composer<_$AppDatabase, $TableUsersTable> {
  $$TableUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TableUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $TableUsersTable> {
  $$TableUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TableUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableUsersTable> {
  $$TableUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TableUsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TableUsersTable,
    UserLocalDto,
    $$TableUsersTableFilterComposer,
    $$TableUsersTableOrderingComposer,
    $$TableUsersTableAnnotationComposer,
    $$TableUsersTableCreateCompanionBuilder,
    $$TableUsersTableUpdateCompanionBuilder,
    (
      UserLocalDto,
      BaseReferences<_$AppDatabase, $TableUsersTable, UserLocalDto>
    ),
    UserLocalDto,
    PrefetchHooks Function()> {
  $$TableUsersTableTableManager(_$AppDatabase db, $TableUsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TableUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
          }) =>
              TableUsersCompanion(
            id: id,
            username: username,
            name: name,
            role: role,
            photoUrl: photoUrl,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String name,
            required String role,
            Value<String?> photoUrl = const Value.absent(),
            required String updatedAt,
          }) =>
              TableUsersCompanion.insert(
            id: id,
            username: username,
            name: name,
            role: role,
            photoUrl: photoUrl,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TableUsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TableUsersTable,
    UserLocalDto,
    $$TableUsersTableFilterComposer,
    $$TableUsersTableOrderingComposer,
    $$TableUsersTableAnnotationComposer,
    $$TableUsersTableCreateCompanionBuilder,
    $$TableUsersTableUpdateCompanionBuilder,
    (
      UserLocalDto,
      BaseReferences<_$AppDatabase, $TableUsersTable, UserLocalDto>
    ),
    UserLocalDto,
    PrefetchHooks Function()>;
typedef $$TableTracksTableCreateCompanionBuilder = TableTracksCompanion
    Function({
  Value<int> id,
  required int userId,
  required int lesson,
  required int year,
  required int sora,
  Value<String> memorized,
  Value<String> read,
});
typedef $$TableTracksTableUpdateCompanionBuilder = TableTracksCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<int> lesson,
  Value<int> year,
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

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lesson => $composableBuilder(
      column: $table.lesson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lesson => $composableBuilder(
      column: $table.lesson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get lesson =>
      $composableBuilder(column: $table.lesson, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

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
            Value<int> userId = const Value.absent(),
            Value<int> lesson = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> sora = const Value.absent(),
            Value<String> memorized = const Value.absent(),
            Value<String> read = const Value.absent(),
          }) =>
              TableTracksCompanion(
            id: id,
            userId: userId,
            lesson: lesson,
            year: year,
            sora: sora,
            memorized: memorized,
            read: read,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int lesson,
            required int year,
            required int sora,
            Value<String> memorized = const Value.absent(),
            Value<String> read = const Value.absent(),
          }) =>
              TableTracksCompanion.insert(
            id: id,
            userId: userId,
            lesson: lesson,
            year: year,
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
  $$TableUsersTableTableManager get tableUsers =>
      $$TableUsersTableTableManager(_db, _db.tableUsers);
  $$TableTracksTableTableManager get tableTracks =>
      $$TableTracksTableTableManager(_db, _db.tableTracks);
}
