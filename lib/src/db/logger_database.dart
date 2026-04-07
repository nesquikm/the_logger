import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:the_logger/src/db/database_path.dart';
import 'package:the_logger/src/db/logger_tables.dart';

part 'logger_database.g.dart';

/// Drift database for the logger package.
@DriftDatabase(tables: [Sessions, Records])
class LoggerDatabase extends _$LoggerDatabase {
  /// Creates the logger database.
  LoggerDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'logs.db',
      native: nativeDatabaseOptions('logs.db'),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
