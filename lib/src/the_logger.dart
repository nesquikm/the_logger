import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:the_logger/src/abstract_logger.dart';
import 'package:the_logger/src/console_logger.dart';
import 'package:the_logger/src/db_logger.dart';

export 'abstract_logger.dart';

/// The Logger: modularity, extensibility, testability
class TheLogger {
  /// Get logger instance
  factory TheLogger.i() {
    _instance ??= TheLogger._();
    return _instance!;
  }
  TheLogger._();

  static TheLogger? _instance;

  final _log = Logger('TheLogger');
  late List<AbstractLogger> _loggers = [];
  Level _minLevel = Level.ALL;
  String? _sessionStartExtra;
  late Level _sessionStartLevel;

  bool _initialized = false;

  /// Init app logger
  ///
  /// [retainStrategy] processing algorythm:
  /// * sort all records by level (ALL->OFF)
  /// * record with minimum level will be used as global filter
  ///   (for storing and printing)
  /// * each integer for a level means how many sessions the records with this
  ///   level will be retained
  /// * each next entry will add this number
  /// * if [retainStrategy] is empty => {Level.ALL: 10}
  /// So, examples:
  ///
  /// {
  ///   Level.ALL:      200,  // ALL records with be deleted after 200 sessions
  ///   Level.INFO:     100,  // records with INFO and higher level retained for 300 sessions
  ///   Level.SEVERE:   50,   // records with SEVERE and higher level retained for 350 sessions
  /// }
  ///
  /// {
  ///   Level.CONFIG:   200,  // records with CONFIG and higher level retained for 200 sessions
  ///                         // lower level records (FINE, FINER and FINEST) will not
  ///                         // be printed nor stored because lowest level in the map
  ///                         // is CONFIG
  ///   Level.INFO:     100,  // records with INFO and higher level retained for 300 sessions
  ///   Level.SEVERE:   50,   // records with SEVERE and higher level retained for 350 sessions
  /// }
  ///
  /// {
  ///   Level.OFF:   0,       // disable logging
  /// }
  ///
  /// {
  ///   Level.ALL:   1,       // all level records will be retained for 1 session
  ///                         // (i.e. you will be able to retrieve the logs from the
  ///                         // previous run)
  /// }
  /// [startNewSession] - if true, new session will be started
  /// [consoleLogger] - if true, console logger will be used
  /// [dbLogger] - if true, db logger will be used
  /// [consoleLoggerCallback] - callback for console logger
  /// [sessionStartExtra] - extra info for session start, will be added to all
  /// session start records
  /// [customLoggers] - custom loggers
  /// [sessionStartLevel] - session start log level
  Future<void> init({
    Map<Level, int> retainStrategy = const {},
    bool startNewSession = true,
    bool consoleLogger = true,
    bool dbLogger = true,
    ConsoleLoggerCallback? consoleLoggerCallback,
    String? sessionStartExtra,
    List<AbstractLogger>? customLoggers,
    Level sessionStartLevel = Level.INFO,
  }) async {
    if (_initialized) {
      _log.warning('TheLogger is already initialized!');
      return;
    }

    _initialized = true;

    _sessionStartExtra = sessionStartExtra;
    _sessionStartLevel = sessionStartLevel;

    // If there are no explicit instructions on how to retain logs
    final retainStrategyNotEmpty =
        retainStrategy.isEmpty ? _defaultRetainStrategy() : retainStrategy;

    _minLevel = retainStrategyNotEmpty.keys.reduce(
      (value, element) => element.compareTo(value) < 0 ? element : value,
    );

    Logger.root.level = _minLevel;
    _loggers = <AbstractLogger>[
      if (consoleLogger) ConsoleLogger(consoleLoggerCallback),
      if (dbLogger) DbLogger(),
      ...customLoggers ?? [],
    ];

    for (final logger in _loggers) {
      await logger.init(retainStrategyNotEmpty);
    }

    Logger.root.clearListeners();
    Logger.root.onRecord.listen(_writeRecord);

    if (startNewSession) await startSession();
  }

  /// Dispose logger
  Future<void> dispose() async {
    _assureInitialized();

    _instance = null;
  }

  /// Get computed minimal level
  Level get minLevel => _minLevel;

  void _writeRecord(LogRecord record) {
    for (final logger in _loggers) {
      logger.write(record);
    }
  }

  /// Increment session id
  Future<void> startSession() async {
    _assureInitialized();

    final logStrings = <String>[];
    for (final logger in _loggers) {
      final logString = await logger.sessionStart();
      if (logString != null) {
        logStrings.add(logString);
      }
    }

    final logStringsReduced = logStrings.fold(
      '',
      (value, element) => value = '$value$element',
    );

    final extraString =
        _sessionStartExtra == null ? '' : ' $_sessionStartExtra';
    _log.log(
      _sessionStartLevel,
      'Session start $logStringsReduced$extraString',
    );
  }

  /// Get all logs as strings (for debug purposes only)
  Future<String> getAllLogsAsString() async {
    _assureInitialized();

    return _dbLogger.getAllLogsAsString();
  }

  /// Get all logs as [LogRecord]s (for debug purposes only)
  @visibleForTesting
  Future<List<LogRecord>> getAllLogs() async {
    _assureInitialized();

    return _dbLogger.getAllLogs();
  }

  /// Get all logs as maps (for debug purposes only)
  @visibleForTesting
  Future<List<Map<String, Object?>>> getAllLogsAsMaps() async {
    _assureInitialized();

    return _dbLogger.getAllLogsAsMaps();
  }

  /// Write logs to archived JSON, return file path
  Future<String> writeAllLogsToJson([String filename = 'logs.json']) async {
    _assureInitialized();

    return _dbLogger.writeAllLogsToJson(filename);
  }

  /// Clear logs (for debug purposes only)
  @visibleForTesting
  Future<void> clearAllLogs() {
    _assureInitialized();

    return _dbLogger.clearAllLogs();
  }

  DbLogger get _dbLogger {
    final dbLogger =
        _loggers.firstWhereOrNull((logger) => logger is DbLogger) as DbLogger?;
    if (dbLogger == null) {
      throw Exception('DbLogger is not initialized!');
    }

    return dbLogger;
  }

  /// Default retain strategy
  Map<Level, int> _defaultRetainStrategy() => {Level.ALL: 10};

  void _assureInitialized() {
    if (!_initialized) {
      throw Exception('TheLogger is not initialized!');
    }
  }
}
