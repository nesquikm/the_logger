import 'dart:async';

import 'package:logging/logging.dart';
import 'package:the_logger/src/models/models.dart';

/// Masked log record
class MaskedLogRecord extends LogRecord {
  /// Create masked log record
  MaskedLogRecord(
    super.level,
    super.message,
    super.loggerName,
    super.error,
    super.stackTrace,
    super.zone,
    super.object, {
    required this.maskedMessage,
    required this.maskedError,
    required this.maskedStackTrace,
  });

  /// Create masked log record from log record fields
  factory MaskedLogRecord.fromLogRecordFields(
    Level level,
    String message,
    String loggerName,
    Object? error,
    StackTrace? stackTrace,
    Zone? zone,
    Object? object, {
    MaskingStrings maskingStrings = const {},
  }) {
    return MaskedLogRecord(
      level,
      message,
      loggerName,
      error,
      stackTrace,
      zone,
      object,
      maskedMessage: maskingStrings.mask(message),
      maskedError: error == null ? null : maskingStrings.mask(error.toString()),
      maskedStackTrace: stackTrace == null
          ? null
          : maskingStrings.mask(stackTrace.toString()),
    );
  }

  /// Create masked log record from log record
  factory MaskedLogRecord.fromLogRecord(
    LogRecord record, {
    required MaskingStrings maskingStrings,
  }) =>
      MaskedLogRecord.fromLogRecordFields(
        record.level,
        record.message,
        record.loggerName,
        record.error,
        record.stackTrace,
        record.zone,
        record.object,
        maskingStrings: maskingStrings,
      );

  /// Masked message
  final String maskedMessage;

  /// Masked error
  final String? maskedError;

  /// Masked stack trace
  final String? maskedStackTrace;
}
