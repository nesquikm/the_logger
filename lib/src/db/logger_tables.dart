import 'package:drift/drift.dart';

/// Sessions table — one row per app session.
class Sessions extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Session start timestamp (text via CURRENT_TIMESTAMP).
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

/// Records table — one row per log entry.
class Records extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Record creation timestamp (text via CURRENT_TIMESTAMP).
  DateTimeColumn get recordTimestamp =>
      dateTime().withDefault(currentDateAndTime)();

  /// Foreign key to sessions (no .references — see tech spec).
  IntColumn get sessionId => integer().nullable()();

  /// Log level value.
  IntColumn get level => integer().nullable()();

  /// Log message.
  TextColumn get message => text().nullable()();

  /// Logger name.
  TextColumn get loggerName => text().nullable()();

  /// Error string.
  TextColumn get error => text().nullable()();

  /// Stack trace string.
  TextColumn get stackTrace => text().nullable()();

  /// Microseconds since epoch (raw integer, NOT DateTimeColumn).
  IntColumn get time => integer().nullable()();
}
