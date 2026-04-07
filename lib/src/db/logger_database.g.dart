// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logger_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  /// Auto-incrementing primary key.
  final int id;

  /// Session start timestamp (text via CURRENT_TIMESTAMP).
  final DateTime timestamp;
  const Session({required this.id, required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(id: Value(id), timestamp: Value(timestamp));
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  Session copyWith({int? id, DateTime? timestamp}) =>
      Session(id: id ?? this.id, timestamp: timestamp ?? this.timestamp);
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.timestamp == this.timestamp);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  SessionsCompanion copyWith({Value<int>? id, Value<DateTime>? timestamp}) {
    return SessionsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $RecordsTable extends Records with TableInfo<$RecordsTable, Record> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recordTimestampMeta = const VerificationMeta(
    'recordTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> recordTimestamp =
      GeneratedColumn<DateTime>(
        'record_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loggerNameMeta = const VerificationMeta(
    'loggerName',
  );
  @override
  late final GeneratedColumn<String> loggerName = GeneratedColumn<String>(
    'logger_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stackTraceMeta = const VerificationMeta(
    'stackTrace',
  );
  @override
  late final GeneratedColumn<String> stackTrace = GeneratedColumn<String>(
    'stack_trace',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordTimestamp,
    sessionId,
    level,
    message,
    loggerName,
    error,
    stackTrace,
    time,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(
    Insertable<Record> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_timestamp')) {
      context.handle(
        _recordTimestampMeta,
        recordTimestamp.isAcceptableOrUnknown(
          data['record_timestamp']!,
          _recordTimestampMeta,
        ),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('logger_name')) {
      context.handle(
        _loggerNameMeta,
        loggerName.isAcceptableOrUnknown(data['logger_name']!, _loggerNameMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('stack_trace')) {
      context.handle(
        _stackTraceMeta,
        stackTrace.isAcceptableOrUnknown(data['stack_trace']!, _stackTraceMeta),
      );
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Record map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Record(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_timestamp'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      loggerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logger_name'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      stackTrace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stack_trace'],
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      ),
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }
}

class Record extends DataClass implements Insertable<Record> {
  /// Auto-incrementing primary key.
  final int id;

  /// Record creation timestamp (text via CURRENT_TIMESTAMP).
  final DateTime recordTimestamp;

  /// Foreign key to sessions (no .references — see tech spec).
  final int? sessionId;

  /// Log level value.
  final int? level;

  /// Log message.
  final String? message;

  /// Logger name.
  final String? loggerName;

  /// Error string.
  final String? error;

  /// Stack trace string.
  final String? stackTrace;

  /// Microseconds since epoch (raw integer, NOT DateTimeColumn).
  final int? time;
  const Record({
    required this.id,
    required this.recordTimestamp,
    this.sessionId,
    this.level,
    this.message,
    this.loggerName,
    this.error,
    this.stackTrace,
    this.time,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_timestamp'] = Variable<DateTime>(recordTimestamp);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<int>(sessionId);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<int>(level);
    }
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || loggerName != null) {
      map['logger_name'] = Variable<String>(loggerName);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    if (!nullToAbsent || stackTrace != null) {
      map['stack_trace'] = Variable<String>(stackTrace);
    }
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<int>(time);
    }
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      id: Value(id),
      recordTimestamp: Value(recordTimestamp),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      level: level == null && nullToAbsent
          ? const Value.absent()
          : Value(level),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      loggerName: loggerName == null && nullToAbsent
          ? const Value.absent()
          : Value(loggerName),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      stackTrace: stackTrace == null && nullToAbsent
          ? const Value.absent()
          : Value(stackTrace),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
    );
  }

  factory Record.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Record(
      id: serializer.fromJson<int>(json['id']),
      recordTimestamp: serializer.fromJson<DateTime>(json['recordTimestamp']),
      sessionId: serializer.fromJson<int?>(json['sessionId']),
      level: serializer.fromJson<int?>(json['level']),
      message: serializer.fromJson<String?>(json['message']),
      loggerName: serializer.fromJson<String?>(json['loggerName']),
      error: serializer.fromJson<String?>(json['error']),
      stackTrace: serializer.fromJson<String?>(json['stackTrace']),
      time: serializer.fromJson<int?>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordTimestamp': serializer.toJson<DateTime>(recordTimestamp),
      'sessionId': serializer.toJson<int?>(sessionId),
      'level': serializer.toJson<int?>(level),
      'message': serializer.toJson<String?>(message),
      'loggerName': serializer.toJson<String?>(loggerName),
      'error': serializer.toJson<String?>(error),
      'stackTrace': serializer.toJson<String?>(stackTrace),
      'time': serializer.toJson<int?>(time),
    };
  }

  Record copyWith({
    int? id,
    DateTime? recordTimestamp,
    Value<int?> sessionId = const Value.absent(),
    Value<int?> level = const Value.absent(),
    Value<String?> message = const Value.absent(),
    Value<String?> loggerName = const Value.absent(),
    Value<String?> error = const Value.absent(),
    Value<String?> stackTrace = const Value.absent(),
    Value<int?> time = const Value.absent(),
  }) => Record(
    id: id ?? this.id,
    recordTimestamp: recordTimestamp ?? this.recordTimestamp,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    level: level.present ? level.value : this.level,
    message: message.present ? message.value : this.message,
    loggerName: loggerName.present ? loggerName.value : this.loggerName,
    error: error.present ? error.value : this.error,
    stackTrace: stackTrace.present ? stackTrace.value : this.stackTrace,
    time: time.present ? time.value : this.time,
  );
  Record copyWithCompanion(RecordsCompanion data) {
    return Record(
      id: data.id.present ? data.id.value : this.id,
      recordTimestamp: data.recordTimestamp.present
          ? data.recordTimestamp.value
          : this.recordTimestamp,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      level: data.level.present ? data.level.value : this.level,
      message: data.message.present ? data.message.value : this.message,
      loggerName: data.loggerName.present
          ? data.loggerName.value
          : this.loggerName,
      error: data.error.present ? data.error.value : this.error,
      stackTrace: data.stackTrace.present
          ? data.stackTrace.value
          : this.stackTrace,
      time: data.time.present ? data.time.value : this.time,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Record(')
          ..write('id: $id, ')
          ..write('recordTimestamp: $recordTimestamp, ')
          ..write('sessionId: $sessionId, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('loggerName: $loggerName, ')
          ..write('error: $error, ')
          ..write('stackTrace: $stackTrace, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recordTimestamp,
    sessionId,
    level,
    message,
    loggerName,
    error,
    stackTrace,
    time,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Record &&
          other.id == this.id &&
          other.recordTimestamp == this.recordTimestamp &&
          other.sessionId == this.sessionId &&
          other.level == this.level &&
          other.message == this.message &&
          other.loggerName == this.loggerName &&
          other.error == this.error &&
          other.stackTrace == this.stackTrace &&
          other.time == this.time);
}

class RecordsCompanion extends UpdateCompanion<Record> {
  final Value<int> id;
  final Value<DateTime> recordTimestamp;
  final Value<int?> sessionId;
  final Value<int?> level;
  final Value<String?> message;
  final Value<String?> loggerName;
  final Value<String?> error;
  final Value<String?> stackTrace;
  final Value<int?> time;
  const RecordsCompanion({
    this.id = const Value.absent(),
    this.recordTimestamp = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.loggerName = const Value.absent(),
    this.error = const Value.absent(),
    this.stackTrace = const Value.absent(),
    this.time = const Value.absent(),
  });
  RecordsCompanion.insert({
    this.id = const Value.absent(),
    this.recordTimestamp = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.level = const Value.absent(),
    this.message = const Value.absent(),
    this.loggerName = const Value.absent(),
    this.error = const Value.absent(),
    this.stackTrace = const Value.absent(),
    this.time = const Value.absent(),
  });
  static Insertable<Record> custom({
    Expression<int>? id,
    Expression<DateTime>? recordTimestamp,
    Expression<int>? sessionId,
    Expression<int>? level,
    Expression<String>? message,
    Expression<String>? loggerName,
    Expression<String>? error,
    Expression<String>? stackTrace,
    Expression<int>? time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordTimestamp != null) 'record_timestamp': recordTimestamp,
      if (sessionId != null) 'session_id': sessionId,
      if (level != null) 'level': level,
      if (message != null) 'message': message,
      if (loggerName != null) 'logger_name': loggerName,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stack_trace': stackTrace,
      if (time != null) 'time': time,
    });
  }

  RecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? recordTimestamp,
    Value<int?>? sessionId,
    Value<int?>? level,
    Value<String?>? message,
    Value<String?>? loggerName,
    Value<String?>? error,
    Value<String?>? stackTrace,
    Value<int?>? time,
  }) {
    return RecordsCompanion(
      id: id ?? this.id,
      recordTimestamp: recordTimestamp ?? this.recordTimestamp,
      sessionId: sessionId ?? this.sessionId,
      level: level ?? this.level,
      message: message ?? this.message,
      loggerName: loggerName ?? this.loggerName,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordTimestamp.present) {
      map['record_timestamp'] = Variable<DateTime>(recordTimestamp.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (loggerName.present) {
      map['logger_name'] = Variable<String>(loggerName.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (stackTrace.present) {
      map['stack_trace'] = Variable<String>(stackTrace.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('id: $id, ')
          ..write('recordTimestamp: $recordTimestamp, ')
          ..write('sessionId: $sessionId, ')
          ..write('level: $level, ')
          ..write('message: $message, ')
          ..write('loggerName: $loggerName, ')
          ..write('error: $error, ')
          ..write('stackTrace: $stackTrace, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

abstract class _$LoggerDatabase extends GeneratedDatabase {
  _$LoggerDatabase(QueryExecutor e) : super(e);
  $LoggerDatabaseManager get managers => $LoggerDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $RecordsTable records = $RecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sessions, records];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({Value<int> id, Value<DateTime> timestamp});
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({Value<int> id, Value<DateTime> timestamp});

class $$SessionsTableFilterComposer
    extends Composer<_$LoggerDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$LoggerDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$LoggerDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$LoggerDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$LoggerDatabase, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$LoggerDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => SessionsCompanion(id: id, timestamp: timestamp),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => SessionsCompanion.insert(id: id, timestamp: timestamp),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LoggerDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$LoggerDatabase, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$RecordsTableCreateCompanionBuilder =
    RecordsCompanion Function({
      Value<int> id,
      Value<DateTime> recordTimestamp,
      Value<int?> sessionId,
      Value<int?> level,
      Value<String?> message,
      Value<String?> loggerName,
      Value<String?> error,
      Value<String?> stackTrace,
      Value<int?> time,
    });
typedef $$RecordsTableUpdateCompanionBuilder =
    RecordsCompanion Function({
      Value<int> id,
      Value<DateTime> recordTimestamp,
      Value<int?> sessionId,
      Value<int?> level,
      Value<String?> message,
      Value<String?> loggerName,
      Value<String?> error,
      Value<String?> stackTrace,
      Value<int?> time,
    });

class $$RecordsTableFilterComposer
    extends Composer<_$LoggerDatabase, $RecordsTable> {
  $$RecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordTimestamp => $composableBuilder(
    column: $table.recordTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggerName => $composableBuilder(
    column: $table.loggerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordsTableOrderingComposer
    extends Composer<_$LoggerDatabase, $RecordsTable> {
  $$RecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordTimestamp => $composableBuilder(
    column: $table.recordTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggerName => $composableBuilder(
    column: $table.loggerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordsTableAnnotationComposer
    extends Composer<_$LoggerDatabase, $RecordsTable> {
  $$RecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordTimestamp => $composableBuilder(
    column: $table.recordTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get loggerName => $composableBuilder(
    column: $table.loggerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<String> get stackTrace => $composableBuilder(
    column: $table.stackTrace,
    builder: (column) => column,
  );

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);
}

class $$RecordsTableTableManager
    extends
        RootTableManager<
          _$LoggerDatabase,
          $RecordsTable,
          Record,
          $$RecordsTableFilterComposer,
          $$RecordsTableOrderingComposer,
          $$RecordsTableAnnotationComposer,
          $$RecordsTableCreateCompanionBuilder,
          $$RecordsTableUpdateCompanionBuilder,
          (Record, BaseReferences<_$LoggerDatabase, $RecordsTable, Record>),
          Record,
          PrefetchHooks Function()
        > {
  $$RecordsTableTableManager(_$LoggerDatabase db, $RecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> recordTimestamp = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<int?> level = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String?> loggerName = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> stackTrace = const Value.absent(),
                Value<int?> time = const Value.absent(),
              }) => RecordsCompanion(
                id: id,
                recordTimestamp: recordTimestamp,
                sessionId: sessionId,
                level: level,
                message: message,
                loggerName: loggerName,
                error: error,
                stackTrace: stackTrace,
                time: time,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> recordTimestamp = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<int?> level = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String?> loggerName = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<String?> stackTrace = const Value.absent(),
                Value<int?> time = const Value.absent(),
              }) => RecordsCompanion.insert(
                id: id,
                recordTimestamp: recordTimestamp,
                sessionId: sessionId,
                level: level,
                message: message,
                loggerName: loggerName,
                error: error,
                stackTrace: stackTrace,
                time: time,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$LoggerDatabase,
      $RecordsTable,
      Record,
      $$RecordsTableFilterComposer,
      $$RecordsTableOrderingComposer,
      $$RecordsTableAnnotationComposer,
      $$RecordsTableCreateCompanionBuilder,
      $$RecordsTableUpdateCompanionBuilder,
      (Record, BaseReferences<_$LoggerDatabase, $RecordsTable, Record>),
      Record,
      PrefetchHooks Function()
    >;

class $LoggerDatabaseManager {
  final _$LoggerDatabase _db;
  $LoggerDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$RecordsTableTableManager get records =>
      $$RecordsTableTableManager(_db, _db.records);
}
