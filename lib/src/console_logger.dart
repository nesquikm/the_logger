import 'dart:async';
import 'dart:developer' as developer;

import 'package:logging/logging.dart';
import 'package:the_logger/src/abstract_logger.dart';
import 'package:the_logger/src/models/models.dart';

/// Console logger
class ConsoleLogger extends AbstractLogger {
  /// Create console logger
  ConsoleLogger(this._loggerCallback);

  final ConsoleLoggerCallback? _loggerCallback;

  @override
  void write(LogRecord record) {
    var trace = record.error?.toString();
    trace = trace != null ? '\n$trace\n' : '';
    final message = _colorMessage(
      '${record.level.name}: ${record.time}: ${record.message}$trace',
      record.level,
    );
    developer.log(
      message,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
    _loggerCallback?.call(
      message,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  }

  String _colorMessage(String message, Level level) {
    final colorString = _colorMap[level]?.value ?? '';

    return '$colorString$message${ConsoleColor.reset.value}';
  }

  /// The color map
  final Map<Level, ConsoleColor> _colorMap = {
    Level.FINEST: ConsoleColor.green0,
    Level.FINER: ConsoleColor.green1,
    Level.FINE: ConsoleColor.green2,
    Level.CONFIG: ConsoleColor.blue0,
    Level.INFO: ConsoleColor.blue1,
    Level.WARNING: ConsoleColor.yellow0,
    Level.SEVERE: ConsoleColor.red0,
    Level.SHOUT: ConsoleColor.redInverse,
  };
}

/// Console logger callback. Mostly for debugging and testing purpose.
typedef ConsoleLoggerCallback = void Function(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level,
  String name,
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
});
