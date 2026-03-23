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

  group('TheLogger stream', () {
    test('emits log records in real-time', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final records = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream.listen(records.add);

      log
        ..info('hello stream')
        ..warning('warning stream');

      // Allow microtasks to complete
      await Future<void>.delayed(Duration.zero);

      expect(records, hasLength(2));
      expect(records[0].message, 'hello stream');
      expect(records[0].level, Level.INFO);
      expect(records[1].message, 'warning stream');
      expect(records[1].level, Level.WARNING);

      await sub.cancel();
    });

    test('is a broadcast stream (supports multiple listeners)', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final records1 = <MaskedLogRecord>[];
      final records2 = <MaskedLogRecord>[];
      final sub1 = TheLogger.i().stream.listen(records1.add);
      final sub2 = TheLogger.i().stream.listen(records2.add);

      log.info('broadcast test');
      await Future<void>.delayed(Duration.zero);

      expect(records1, hasLength(1));
      expect(records2, hasLength(1));
      expect(records1[0].message, 'broadcast test');
      expect(records2[0].message, 'broadcast test');

      await sub1.cancel();
      await sub2.cancel();
    });

    test('includes masked data', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );
      TheLogger.i().addMaskingString(MaskingString('secret'));

      final records = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream.listen(records.add);

      log.info('my secret value');
      await Future<void>.delayed(Duration.zero);

      expect(records, hasLength(1));
      expect(records[0].message, 'my secret value');
      expect(records[0].maskedMessage, 'my *** value');

      await sub.cancel();
    });

    test('can be filtered by level', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final warnings = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream
          .where((r) => r.level >= Level.WARNING)
          .listen(warnings.add);

      log
        ..info('info msg')
        ..warning('warning msg')
        ..severe('severe msg');
      await Future<void>.delayed(Duration.zero);

      expect(warnings, hasLength(2));
      expect(warnings[0].message, 'warning msg');
      expect(warnings[1].message, 'severe msg');

      await sub.cancel();
    });

    test('can be filtered by logger name', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final otherLog = Logger('OtherLogger');
      final filtered = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream
          .where((r) => r.loggerName == 'TestLogger')
          .listen(filtered.add);

      log.info('from test');
      otherLog.info('from other');
      await Future<void>.delayed(Duration.zero);

      expect(filtered, hasLength(1));
      expect(filtered[0].message, 'from test');

      await sub.cancel();
    });

    test('stops emitting after dispose', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final records = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream.listen(records.add);

      log.info('before dispose');
      await Future<void>.delayed(Duration.zero);
      expect(records, hasLength(1));

      await TheLogger.i().dispose();

      // After dispose, new TheLogger instance should have a fresh stream
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final newRecords = <MaskedLogRecord>[];
      final newSub = TheLogger.i().stream.listen(newRecords.add);

      log.info('after re-init');
      await Future<void>.delayed(Duration.zero);

      // Old subscription should not get new records (stream was closed)
      expect(records, hasLength(1));
      // New subscription should work
      expect(newRecords, hasLength(1));
      expect(newRecords[0].message, 'after re-init');

      await sub.cancel();
      await newSub.cancel();
    });

    test('works alongside other loggers', () async {
      final customRecords = <MaskedLogRecord>[];

      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
        customLoggers: [_CallbackLogger(customRecords.add)],
      );

      final streamRecords = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream.listen(streamRecords.add);

      log.info('dual output');
      await Future<void>.delayed(Duration.zero);

      // Both the custom logger and stream should receive the record
      expect(customRecords, hasLength(1));
      expect(streamRecords, hasLength(1));
      expect(customRecords[0].message, 'dual output');
      expect(streamRecords[0].message, 'dual output');

      await sub.cancel();
    });

    test('emits all log levels', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final records = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream.listen(records.add);

      log
        ..finest('finest')
        ..finer('finer')
        ..fine('fine')
        ..config('config')
        ..info('info')
        ..warning('warning')
        ..severe('severe')
        ..shout('shout');

      await Future<void>.delayed(Duration.zero);

      expect(records, hasLength(8));
      expect(records[0].level, Level.FINEST);
      expect(records[7].level, Level.SHOUT);

      await sub.cancel();
    });

    test('includes error and stack trace', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final records = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream.listen(records.add);

      final stackTrace = StackTrace.fromString('fake stack');
      log.severe('something failed', 'the error', stackTrace);
      await Future<void>.delayed(Duration.zero);

      expect(records, hasLength(1));
      expect(records[0].message, 'something failed');
      expect(records[0].error.toString(), 'the error');
      expect(records[0].stackTrace.toString(), 'fake stack');

      await sub.cancel();
    });

    test('cancelled subscription stops receiving events', () async {
      await TheLogger.i().init(
        startNewSession: false,
        dbLogger: false,
        consoleLogger: false,
      );

      final records = <MaskedLogRecord>[];
      final sub = TheLogger.i().stream.listen(records.add);

      log.info('before cancel');
      await Future<void>.delayed(Duration.zero);
      expect(records, hasLength(1));

      await sub.cancel();

      log.info('after cancel');
      await Future<void>.delayed(Duration.zero);
      expect(records, hasLength(1));
    });
  });
}

class _CallbackLogger extends AbstractLogger {
  _CallbackLogger(this._callback);

  final void Function(MaskedLogRecord record) _callback;

  @override
  void write(MaskedLogRecord record) {
    _callback(record);
  }
}
