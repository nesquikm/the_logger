import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:the_logger/src/abstract_logger.dart';
import 'package:the_logger/src/models/models.dart';

/// Database logger
class DbLogger extends AbstractLogger {
  late final Database _database;
  late final Map<Level, int> _retainStrategy;
  int _sessionId = -1;

  @override
  Future<void> init(Map<Level, int> retainStrategy) async {
    WidgetsFlutterBinding.ensureInitialized();

    _retainStrategy = retainStrategy;

    _database = await openDatabase(
      join(
        await getDatabasesPath(),
        'logs.db',
      ),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int _) async {
    await db.execute(
      '''
        CREATE TABLE sessions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
        );
      ''',
    );
    await db.execute(
      '''
        CREATE TABLE records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          record_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
          session_id INTEGER,
          level INTEGER,
          message TEXT,
          logger_name TEXT,
          error TEXT,
          stack_trace TEXT,
          time TIMESTAMP
        );
      ''',
    );
  }

  @override
  Future<String?> sessionStart() async {
    await _database.transaction((txn) async {
      _sessionId = await txn.rawInsert(
        '''INSERT INTO sessions DEFAULT VALUES;''',
      );
    });

    Future.delayed(const Duration(milliseconds: 200), _cleanup);

    return 'new session id: $_sessionId';
  }

  @override
  void write(MaskedLogRecord record) {
    if (!_database.isOpen) return;

    _database.insert(
      'records',
      record.toMap(
        sessionId: _sessionId,
        mask: shouldMask,
      ),
    );
  }

  /// Get all logs as strings
  Future<String> getAllLogsAsString() async {
    if (!_database.isOpen) return '';

    final list = await _database.rawQuery(
      '''
        SELECT * FROM records ORDER BY record_timestamp ASC
      ''',
    );

    return list.fold(
      '',
      (previousValue, element) => '$previousValue\n$element',
    );
  }

  /// Get all logs as [LogRecord]s (for debug purposes only)
  Future<List<LogRecord>> getAllLogs() async {
    if (!_database.isOpen) return [];

    final list = await _database.rawQuery(
      '''
        SELECT * FROM records ORDER BY record_timestamp ASC
      ''',
    );

    return list.map(WritableLogRecord.fromMap).toList();
  }

  /// Get all logs as maps (for debug purposes only)
  Future<List<Map<String, Object?>>> getAllLogsAsMaps() async {
    if (!_database.isOpen) return [];

    return _database.rawQuery(
      '''
        SELECT * FROM records ORDER BY record_timestamp ASC
      ''',
    );
  }

  /// Write logs to archived JSON, return file path
  Future<String> writeAllLogsToJson(String filename) async {
    if (!_database.isOpen) return 'Database is not ready';

    final cursor = await _database.rawQueryCursor(
      '''
        SELECT
          logger_name,
          id,
          record_timestamp,
          session_id,
          level,
          message,
          error,
          stack_trace,
          time
        FROM records ORDER BY record_timestamp ASC
      ''',
      [],
    );

    final fileAcrhive = _FileAcrhive();
    final filePath = await fileAcrhive.open(filename);

    await fileAcrhive.writeString('{\n  "logs": [\n');

    try {
      var isFirst = true;
      while (await cursor.moveNext()) {
        final row = cursor.current;
        final string = json.encode(row);
        final comma = isFirst ? '' : ',\n';
        await fileAcrhive.writeString('$comma    $string');
        isFirst = false;
      }
    } finally {
      await cursor.close();
    }

    await fileAcrhive.writeString('\n  ]\n}');

    await fileAcrhive.close();

    return filePath;
  }

  Future<void> _cleanup() async {
    if (!_database.isOpen || _sessionId < 0 || _retainStrategy.isEmpty) return;

    final levelList = _retainStrategy.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    Level? nextLevel;
    var retain = _sessionId;
    final leveListWithBouds = levelList
        .map(
          (e) {
            final ret = _LevelBound(
              level: e.key,
              nextLevel: nextLevel,
              sessionId: e.value,
            );
            nextLevel = e.key;

            return ret;
          },
        )
        .toList()
        .reversed
        .map((e) {
          retain -= e.sessionId;

          return e.copyWith(sessionId: retain);
        })
        .toList();

    final where = leveListWithBouds.fold('', (previousValue, element) {
      final previous = previousValue.isNotEmpty ? '$previousValue OR ' : '';
      final next = element.nextLevel == null
          ? ''
          : 'AND level < ${element.nextLevel!.value}';

      return '''
        $previous(session_id < ${element.sessionId} AND level >= ${element.level.value} $next)
        ''';
    });

    final query = '''
      DELETE FROM records WHERE $where;
    ''';

    unawaited(_database.execute(query));
  }

  /// Clear logs (for debug purposes only)
  Future<void> clearAllLogs() async {
    const query = '''
      DELETE FROM records;
    ''';

    await _database.execute(query);
  }

  /// Whether to mask logs
  bool shouldMask = true;
}

class _LevelBound {
  _LevelBound({
    required this.level,
    required this.nextLevel,
    required this.sessionId,
  });
  final Level level;
  final Level? nextLevel;
  final int sessionId;

  _LevelBound copyWith({int? sessionId}) => _LevelBound(
        level: level,
        nextLevel: nextLevel,
        sessionId: sessionId ?? this.sessionId,
      );
}

class _FileAcrhive {
  _FileAcrhive();

  IOSink? _file;
  final _encoder = gzip.encoder;
  Sink<List<int>>? _sink;

  Future<String> open(String filename) async {
    await close();

    final filePath = join(
      (await getTemporaryDirectory()).path,
      '$filename.gzip',
    );

    try {
      await File(filePath).delete();
    } catch (_) {}

    _file = File(filePath).openWrite();

    _sink = _encoder.startChunkedConversion(_file!);

    return filePath;
  }

  Future<void> close() async {
    _sink?.close();
    await _file?.flush();
    // TODO(nesquikm): idk, but tests fails when this is awaited
    unawaited(_file?.close());
  }

  Future<void> writeString(String string) async {
    _sink!.add(utf8.encode(string));
  }
}
