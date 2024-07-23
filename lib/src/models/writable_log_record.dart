import 'package:logging/logging.dart';
import 'package:the_logger/src/models/models.dart';

/// Db-related extension for Level
extension WritableLevel on Level {
  /// Return Level by value
  static Level fromValue(int value) {
    return Level.LEVELS.firstWhere((element) => element.value == value);
  }
}

/// Db-related extension for LogRecord
extension WritableLogRecord on MaskedLogRecord {
  static const _keySessionId = 'session_id';
  static const _keyLevel = 'level';
  static const _keyMessage = 'message';
  static const _keyLoggerName = 'logger_name';
  static const _keyError = 'error';
  static const _keyStackTrace = 'stack_trace';
  static const _keyTime = 'time';

  /// Prepare structure for writing to db
  Map<String, dynamic> toMap({
    required int sessionId,
    required bool mask,
  }) {
    return {
      _keySessionId: sessionId,
      _keyLevel: level.value,
      _keyMessage: mask ? maskedMessage : message,
      _keyLoggerName: loggerName,
      _keyError: mask ? maskedError : error?.toString(),
      _keyStackTrace: mask ? maskedStackTrace : stackTrace.toString(),
      _keyTime: time.microsecondsSinceEpoch,
    };
  }

  /// Create LogRecord from db record
  static MaskedLogRecord fromMap(
    Map<String, dynamic> map, {
    MaskingStrings maskingStrings = const {},
  }) {
    return MaskedLogRecord.fromLogRecordFields(
      WritableLevel.fromValue(map[_keyLevel] as int),
      map[_keyMessage] as String,
      map[_keyLoggerName] as String,
      map[_keyError] as String,
      StackTrace.fromString(map[_keyStackTrace] as String),
      null,
      null,
      maskingStrings: maskingStrings,
    );
  }
}
