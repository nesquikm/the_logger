import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_logger/src/db/logger_database.dart';

/// Write all logs to a gzipped JSON file, return the file path.
Future<String> writeLogsToFile(
  LoggerDatabase database,
  String filename,
) async {
  final filePath = join(
    (await getTemporaryDirectory()).path,
    '$filename.gzip',
  );

  final file = File(filePath);
  await file.parent.create(recursive: true);

  try {
    await file.delete();
  } on FileSystemException catch (_) {}

  final ioSink = file.openWrite();
  final sink = gzip.encoder.startChunkedConversion(ioSink)
    ..add(utf8.encode('{\n  "logs": [\n'));

  const batchSize = 1000;
  var offset = 0;
  var isFirst = true;

  while (true) {
    final rows = await database.customSelect(
      'SELECT logger_name, id, record_timestamp, session_id, level, '
      'message, error, stack_trace, time '
      'FROM records ORDER BY record_timestamp ASC '
      'LIMIT ? OFFSET ?',
      variables: [Variable.withInt(batchSize), Variable.withInt(offset)],
    ).get();

    if (rows.isEmpty) break;

    for (final row in rows) {
      final comma = isFirst ? '' : ',\n';
      sink.add(utf8.encode('$comma    ${json.encode(row.data)}'));
      isFirst = false;
    }

    offset += batchSize;
  }

  sink
    ..add(utf8.encode('\n  ]\n}'))
    ..close();
  await ioSink.flush();
  // Tests fail when this is awaited (same as original sqflite code).
  unawaited(ioSink.close());

  return filePath;
}
