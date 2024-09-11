// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:the_logger/the_logger.dart';

void main() {
  final log = Logger('TestLogger');

  tearDown(
    () async {
      await TheLogger.i().dispose();
    },
  );

  test('TheLogger console tests', () async {
    final logs = <Map<String, dynamic>>[];

    void consoleLoggerCallback({
      required String formattedRecord,
      required String message,
      DateTime? time,
      int? sequenceNumber,
      int level = 0,
      String name = '',
      Zone? zone,
      Object? error,
      StackTrace? stackTrace,
    }) {
      if (!formattedRecord.contains('hot-reload')) {
        logs.add({
          'formattedRecord': formattedRecord,
          'level': level,
          'name': name,
        });
      }
    }

    await TheLogger.i().init(
      startNewSession: false,
      dbLogger: false,
      consoleLoggerCallback: consoleLoggerCallback,
    );

    await TheLogger.i().startSession();

    log
      ..finest('some finest log')
      ..finer('some finer log')
      ..fine('some fine log')
      ..config('some config log')
      ..info('some info log')
      ..warning('some warning log')
      ..severe('some severe log')
      ..shout('some shout log');

    expect(logs, hasLength(9));

    expect(logs[0]['formattedRecord'], contains('Session start'));
    expect(logs[0]['name'], contains('TheLogger'));

    expect(
      logs[1]['formattedRecord'],
      contains(DefaultConsoleColor.green0.value),
    );
    expect(logs[1]['formattedRecord'], contains('some finest log'));
    expect(
      logs[1]['formattedRecord'],
      contains(DefaultConsoleColor.reset.value),
    );
    expect(logs[1]['name'], contains('TestLogger'));
    expect(logs[1]['level'], Level.FINEST.value);

    expect(
      logs[2]['formattedRecord'],
      contains(DefaultConsoleColor.green1.value),
    );
    expect(logs[2]['formattedRecord'], contains('some finer log'));
    expect(
      logs[2]['formattedRecord'],
      contains(DefaultConsoleColor.reset.value),
    );
    expect(logs[2]['name'], contains('TestLogger'));
    expect(logs[2]['level'], Level.FINER.value);

    expect(
      logs[3]['formattedRecord'],
      contains(DefaultConsoleColor.green2.value),
    );
    expect(logs[3]['formattedRecord'], contains('some fine log'));
    expect(
      logs[3]['formattedRecord'],
      contains(DefaultConsoleColor.reset.value),
    );
    expect(logs[3]['name'], contains('TestLogger'));
    expect(logs[3]['level'], Level.FINE.value);

    expect(
      logs[4]['formattedRecord'],
      contains(DefaultConsoleColor.blue0.value),
    );
    expect(logs[4]['formattedRecord'], contains('some config log'));
    expect(
      logs[4]['formattedRecord'],
      contains(DefaultConsoleColor.reset.value),
    );
    expect(logs[4]['name'], contains('TestLogger'));
    expect(logs[4]['level'], Level.CONFIG.value);

    expect(
      logs[5]['formattedRecord'],
      contains(DefaultConsoleColor.blue1.value),
    );
    expect(logs[5]['formattedRecord'], contains('some info log'));
    expect(
      logs[5]['formattedRecord'],
      contains(DefaultConsoleColor.reset.value),
    );
    expect(logs[5]['name'], contains('TestLogger'));
    expect(logs[5]['level'], Level.INFO.value);

    expect(
      logs[6]['formattedRecord'],
      contains(DefaultConsoleColor.yellow0.value),
    );
    expect(logs[6]['formattedRecord'], contains('some warning log'));
    expect(
      logs[6]['formattedRecord'],
      contains(DefaultConsoleColor.reset.value),
    );
    expect(logs[6]['name'], contains('TestLogger'));
    expect(logs[6]['level'], Level.WARNING.value);

    expect(
      logs[7]['formattedRecord'],
      contains(DefaultConsoleColor.red0.value),
    );
    expect(logs[7]['formattedRecord'], contains('some severe log'));
    expect(
      logs[7]['formattedRecord'],
      contains(DefaultConsoleColor.reset.value),
    );
    expect(logs[7]['name'], contains('TestLogger'));
    expect(logs[7]['level'], Level.SEVERE.value);

    expect(
      logs[8]['formattedRecord'],
      contains(DefaultConsoleColor.red1.value),
    );
    expect(logs[8]['formattedRecord'], contains('some shout log'));
    expect(
      logs[8]['formattedRecord'],
      contains(DefaultConsoleColor.reset.value),
    );
    expect(logs[8]['name'], contains('TestLogger'));
    expect(logs[8]['level'], Level.SHOUT.value);
  });

  test('TheLogger console tests with custom color scheme', () async {
    final logs = <Map<String, dynamic>>[];

    void consoleLoggerCallback({
      required String formattedRecord,
      required String message,
      DateTime? time,
      int? sequenceNumber,
      int level = 0,
      String name = '',
      Zone? zone,
      Object? error,
      StackTrace? stackTrace,
    }) {
      if (!formattedRecord.contains('hot-reload')) {
        logs.add({
          'formattedRecord': formattedRecord,
          'level': level,
          'name': name,
        });
      }
    }

    await TheLogger.i().init(
      startNewSession: false,
      dbLogger: false,
      consoleLoggerCallback: consoleLoggerCallback,
      consoleColors: CustomColors(),
    );

    await TheLogger.i().startSession();

    log
      ..finest('some finest log')
      ..finer('some finer log')
      ..fine('some fine log')
      ..config('some config log')
      ..info('some info log')
      ..warning('some warning log')
      ..severe('some severe log')
      ..shout('some shout log');

    expect(logs, hasLength(9));

    expect(logs[0]['formattedRecord'], contains('Session start'));
    expect(logs[0]['name'], contains('TheLogger'));

    expect(
      logs[1]['formattedRecord'],
      contains('_finest_'),
    );
    expect(logs[1]['formattedRecord'], contains('some finest log'));
    expect(
      logs[1]['formattedRecord'],
      contains('_reset_'),
    );
    expect(logs[1]['name'], contains('TestLogger'));
    expect(logs[1]['level'], Level.FINEST.value);

    expect(
      logs[2]['formattedRecord'],
      contains('_finer_'),
    );
    expect(logs[2]['formattedRecord'], contains('some finer log'));
    expect(
      logs[2]['formattedRecord'],
      contains('_reset_'),
    );
    expect(logs[2]['name'], contains('TestLogger'));
    expect(logs[2]['level'], Level.FINER.value);

    expect(
      logs[3]['formattedRecord'],
      contains('_fine_'),
    );
    expect(logs[3]['formattedRecord'], contains('some fine log'));
    expect(
      logs[3]['formattedRecord'],
      contains('_reset_'),
    );
    expect(logs[3]['name'], contains('TestLogger'));
    expect(logs[3]['level'], Level.FINE.value);

    expect(
      logs[4]['formattedRecord'],
      contains('_config_'),
    );
    expect(logs[4]['formattedRecord'], contains('some config log'));
    expect(
      logs[4]['formattedRecord'],
      contains('_reset_'),
    );
    expect(logs[4]['name'], contains('TestLogger'));
    expect(logs[4]['level'], Level.CONFIG.value);

    expect(
      logs[5]['formattedRecord'],
      contains('_info_'),
    );
    expect(logs[5]['formattedRecord'], contains('some info log'));
    expect(
      logs[5]['formattedRecord'],
      contains('_reset_'),
    );
    expect(logs[5]['name'], contains('TestLogger'));
    expect(logs[5]['level'], Level.INFO.value);

    expect(
      logs[6]['formattedRecord'],
      contains('_warning_'),
    );
    expect(logs[6]['formattedRecord'], contains('some warning log'));
    expect(
      logs[6]['formattedRecord'],
      contains('_reset_'),
    );
    expect(logs[6]['name'], contains('TestLogger'));
    expect(logs[6]['level'], Level.WARNING.value);

    expect(
      logs[7]['formattedRecord'],
      contains('_severe_'),
    );
    expect(logs[7]['formattedRecord'], contains('some severe log'));
    expect(
      logs[7]['formattedRecord'],
      contains('_reset_'),
    );
    expect(logs[7]['name'], contains('TestLogger'));
    expect(logs[7]['level'], Level.SEVERE.value);

    expect(
      logs[8]['formattedRecord'],
      contains('_shout_'),
    );
    expect(logs[8]['formattedRecord'], contains('some shout log'));
    expect(
      logs[8]['formattedRecord'],
      contains('_reset_'),
    );
    expect(logs[8]['name'], contains('TestLogger'));
    expect(logs[8]['level'], Level.SHOUT.value);
  });

  test('TheLogger console startSession extra string test', () async {
    final logs = <Map<String, dynamic>>[];

    void consoleLoggerCallback({
      required String formattedRecord,
      required String message,
      DateTime? time,
      int? sequenceNumber,
      int level = 0,
      String name = '',
      Zone? zone,
      Object? error,
      StackTrace? stackTrace,
    }) {
      if (!formattedRecord.contains('hot-reload')) {
        logs.add({
          'formattedRecord': formattedRecord,
          'level': level,
          'name': name,
        });
      }
    }

    await TheLogger.i().init(
      startNewSession: false,
      dbLogger: false,
      consoleLoggerCallback: consoleLoggerCallback,
      sessionStartExtra: 'extra string',
    );

    await TheLogger.i().startSession();

    expect(logs, hasLength(1));

    expect(logs[0]['formattedRecord'], contains('Session start'));
    expect(logs[0]['formattedRecord'], contains('extra string'));
    expect(logs[0]['name'], contains('TheLogger'));
  });

  test('TheLogger console startSession stack trace test', () async {
    final logs = <Map<String, dynamic>>[];

    void consoleLoggerCallback({
      required String formattedRecord,
      required String message,
      DateTime? time,
      int? sequenceNumber,
      int level = 0,
      String name = '',
      Zone? zone,
      Object? error,
      StackTrace? stackTrace,
    }) {
      if (!formattedRecord.contains('hot-reload')) {
        logs.add(
          {
            'formattedRecord': formattedRecord,
            'level': level,
            'name': name,
            'error': error,
            'stackTrace': stackTrace,
          },
        );
      }
    }

    await TheLogger.i().init(
      startNewSession: false,
      dbLogger: false,
      consoleLoggerCallback: consoleLoggerCallback,
      sessionStartExtra: 'extra string',
    );

    await TheLogger.i().startSession();

    try {
      throw Exception('some exception');
    } catch (e, s) {
      log.severe(e, 'some error', s);
    }

    expect(logs, hasLength(2));
    expect(logs[1]['formattedRecord'], contains('some exception'));
    expect(logs[1]['error'], contains('some error'));
    expect(
      logs[1]['stackTrace'].toString(),
      contains('the_logger/test/console_logger_test'),
    );
  });
}

class CustomColors extends ConsoleColors {
  @override
  String get finest => '_finest_';
  @override
  String get finer => '_finer_';
  @override
  String get fine => '_fine_';
  @override
  String get config => '_config_';
  @override
  String get info => '_info_';
  @override
  String get warning => '_warning_';
  @override
  String get severe => '_severe_';
  @override
  String get shout => '_shout_';
  @override
  String get reset => '_reset_';
}
