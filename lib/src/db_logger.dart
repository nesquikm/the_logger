import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:the_logger/src/abstract_logger.dart';
import 'package:the_logger/src/db/logger_database.dart';
import 'package:the_logger/src/log_export.dart';
import 'package:the_logger/src/models/models.dart';

/// Database logger
class DbLogger extends AbstractLogger {
  late LoggerDatabase _database;
  late final Map<Level, int> _retainStrategy;
  int _sessionId = -1;
  final List<Future<void>> _pendingOperations = [];

  @override
  Future<void> init(
    Map<Level, int> retainStrategy, [
    @visibleForTesting LoggerDatabase? database,
  ]) async {
    WidgetsFlutterBinding.ensureInitialized();

    _retainStrategy = retainStrategy;

    _database = database ?? LoggerDatabase();
  }

  @override
  Future<String?> sessionStart() async {
    _sessionId = await _database
        .into(_database.sessions)
        .insert(SessionsCompanion.insert());

    final cleanupFuture = Future.delayed(
      const Duration(milliseconds: 200),
      _cleanup,
    );
    _pendingOperations.add(cleanupFuture);
    unawaited(
      cleanupFuture.whenComplete(
        () => _pendingOperations.remove(cleanupFuture),
      ),
    );

    return 'new session id: $_sessionId';
  }

  @override
  void write(MaskedLogRecord record) {
    unawaited(
      _database
          .into(_database.records)
          .insert(
            RecordsCompanion.insert(
              sessionId: Value(_sessionId),
              level: Value(record.level.value),
              message: Value(
                shouldMask ? record.maskedMessage : record.message,
              ),
              loggerName: Value(record.loggerName),
              error: Value(
                shouldMask ? record.maskedError : record.error?.toString(),
              ),
              stackTrace: Value(
                shouldMask
                    ? record.maskedStackTrace
                    : record.stackTrace.toString(),
              ),
              time: Value(record.time.microsecondsSinceEpoch),
            ),
          ),
    );
  }

  /// Get all logs as strings
  Future<String> getAllLogsAsString() async {
    final list =
        await (_database.select(_database.records)..orderBy([
              (t) => OrderingTerm.asc(t.recordTimestamp),
            ]))
            .get();

    return list.map((element) => '$element').join('\n');
  }

  /// Get all logs as [LogRecord]s (for debug purposes only)
  Future<List<LogRecord>> getAllLogs() async {
    final list = await _database
        .customSelect(
          'SELECT * FROM records ORDER BY record_timestamp ASC',
        )
        .get();

    return list
        .map((row) => WritableLogRecord.fromMap(row.data.cast()))
        .toList();
  }

  /// Get all logs as maps (for debug purposes only)
  Future<List<Map<String, Object?>>> getAllLogsAsMaps() async {
    final list = await _database
        .customSelect(
          'SELECT * FROM records ORDER BY record_timestamp ASC',
        )
        .get();

    return list.map((row) => row.data.cast<String, Object?>()).toList();
  }

  /// Write logs to archived JSON, return file path
  Future<String> writeAllLogsToJson(String filename) async {
    if (kIsWeb) {
      throw UnsupportedError('Log export is not supported on web');
    }
    return writeLogsToFile(_database, filename);
  }

  Future<void> _cleanup() async {
    if (_sessionId < 0 || _retainStrategy.isEmpty) return;

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

    final query =
        '''
      DELETE FROM records WHERE $where;
    ''';

    await _database.customStatement(query);
  }

  /// Clear logs (for debug purposes only)
  Future<void> clearAllLogs() async {
    await _database.delete(_database.records).go();
  }

  /// Whether to mask logs
  bool shouldMask = true;

  @override
  Future<void> dispose() async {
    await Future.wait(_pendingOperations);
    _pendingOperations.clear();
    await _database.close();
  }
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
