// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:the_logger/the_logger.dart';

class CustomLogger extends AbstractLogger {
  CustomLogger(this._writeCallback, this._sessionStartCallback);

  final void Function(MaskedLogRecord record)? _writeCallback;
  final void Function()? _sessionStartCallback;

  @override
  Future<String?> sessionStart() async {
    _sessionStartCallback?.call();
    return 'custom session started';
  }

  @override
  void write(MaskedLogRecord record) {
    _writeCallback?.call(record);
  }
}

void main() {
  final log = Logger('TestLogger');

  tearDown(
    () async {
      await TheLogger.i().dispose();
    },
  );

  test('Customlogger tests', () async {
    final logs = <LogRecord>[];

    await TheLogger.i().init(
      startNewSession: false,
      dbLogger: false,
      customLoggers: [CustomLogger(logs.add, null)],
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

    expect(logs[0].message, contains('Session start'));
    expect(logs[0].loggerName, contains('TheLogger'));

    expect(logs[1].message, contains('some finest log'));
    expect(logs[1].loggerName, contains('TestLogger'));
    expect(logs[1].level, Level.FINEST);

    expect(logs[2].message, contains('some finer log'));
    expect(logs[2].loggerName, contains('TestLogger'));
    expect(logs[2].level, Level.FINER);

    expect(logs[3].message, contains('some fine log'));
    expect(logs[3].loggerName, contains('TestLogger'));
    expect(logs[3].level, Level.FINE);

    expect(logs[4].message, contains('some config log'));
    expect(logs[4].loggerName, contains('TestLogger'));
    expect(logs[4].level, Level.CONFIG);

    expect(logs[5].message, contains('some info log'));
    expect(logs[5].loggerName, contains('TestLogger'));
    expect(logs[5].level, Level.INFO);

    expect(logs[6].message, contains('some warning log'));
    expect(logs[6].loggerName, contains('TestLogger'));
    expect(logs[6].level, Level.WARNING);

    expect(logs[7].message, contains('some severe log'));
    expect(logs[7].loggerName, contains('TestLogger'));
    expect(logs[7].level, Level.SEVERE);

    expect(logs[8].message, contains('some shout log'));
    expect(logs[8].loggerName, contains('TestLogger'));
    expect(logs[8].level, Level.SHOUT);
  });

  test('Customlogger session test', () async {
    final logs = <LogRecord>[];
    var sessionCount = 0;

    await TheLogger.i().init(
      startNewSession: false,
      dbLogger: false,
      customLoggers: [CustomLogger(logs.add, () => sessionCount++)],
    );

    expect(sessionCount, 0);
    expect(logs, hasLength(0));

    await TheLogger.i().startSession();

    expect(sessionCount, 1);
    expect(logs, hasLength(1));

    expect(logs[0].message, contains('Session start'));
    expect(logs[0].message, contains('custom session started'));
    expect(logs[0].loggerName, contains('TheLogger'));
  });

  test('Customlogger not mask test', () async {
    final logs = <MaskedLogRecord>[];

    await TheLogger.i().init(
      startNewSession: false,
      dbLogger: false,
      customLoggers: [CustomLogger(logs.add, () {})],
    );
    TheLogger.i().addMaskingString(MaskingString('password'));

    log.finest('message with password');
    expect(logs[0].message, contains('message with password'));
    expect(logs[0].maskedMessage, contains('message with ***'));
  });
}
