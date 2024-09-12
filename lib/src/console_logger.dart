import 'dart:async';
import 'dart:developer' as developer;

import 'package:logging/logging.dart';
import 'package:the_logger/src/abstract_logger.dart';
import 'package:the_logger/src/models/models.dart';

/// Console logger
class ConsoleLogger extends AbstractLogger {
  /// Create console logger
  ConsoleLogger({
    this.loggerCallback,
    this.colors = const ConsoleColors(),
    this.formatJson = true,
  });

  /// Console logger callback
  final ConsoleLoggerCallback? loggerCallback;

  /// Console colors
  final ConsoleColors colors;

  /// Format JSON embedded in message and error
  final bool formatJson;

  @override
  void write(MaskedLogRecord record) {
    final formatted = _formatRecord(record);

    developer.log(
      formatted,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
    );

    loggerCallback?.call(
      formattedRecord: formatted,
      message: record.message,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  }

  String _formatRecord(MaskedLogRecord record) {
    final message = record.message;
    final error = (record.error != null ? '\n${record.error}' : '');
    final formattedMessage = formatJson ? message.prettyJson : message;
    final formattedError = formatJson ? error.prettyJson : error;
    final trace = record.stackTrace != null ? '\n${record.stackTrace}' : '';
    return _colorMessage(
      '''${record.level.name}: ${record.time.toIso8601String()} $formattedMessage$formattedError$trace''',
      record.level,
    );
  }

  String _colorMessage(String message, Level level) {
    final colorString = _getLevelColor(level);
    final resetColor = _getResetColor();

    return '$colorString$message$resetColor';
  }

  String _getLevelColor(Level level) {
    return switch (level) {
      Level.FINEST => colors.finest,
      Level.FINER => colors.finer,
      Level.FINE => colors.fine,
      Level.CONFIG => colors.config,
      Level.INFO => colors.info,
      Level.WARNING => colors.warning,
      Level.SEVERE => colors.severe,
      Level.SHOUT => colors.shout,
      _ => '',
    };
  }

  String _getResetColor() => colors.reset;
}

/// Console logger callback. Mostly for debugging and testing purpose.
typedef ConsoleLoggerCallback = void Function({
  required String formattedRecord,
  required String message,
  DateTime? time,
  int? sequenceNumber,
  int level,
  String name,
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
});
