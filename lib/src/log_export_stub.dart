import 'package:the_logger/src/db/logger_database.dart';

/// Log export is not supported on web.
Future<String> writeLogsToFile(
  LoggerDatabase database,
  String filename,
) {
  return Future.error(
    UnsupportedError('Log export is not supported on web'),
  );
}
