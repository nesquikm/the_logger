import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:the_logger/the_logger.dart';

void main() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory, do not use isolate here
  databaseFactory = databaseFactoryFfiNoIsolate;

  final log = Logger('TestLogger');

  tearDown(
    () async {
      await TheLogger.i().dispose();
    },
  );

  group('TheLogger can be instantiated', () {
    test('can be instantiated', () async {
      final logger = TheLogger.i();
      await logger.init();
      expect(logger, isNotNull);
    });
  });

  group('TheLogger mask tests', () {
    test('with mask', () async {
      await TheLogger.i().init(
        retainStrategy: {Level.ALL: 100},
        startNewSession: false,
        sessionStartExtra: 'extra string',
      );
      await TheLogger.i().clearAllLogs();

      TheLogger.i().addMaskingString(MaskingString('password'));

      log.finest('message with password');

      final logs = await TheLogger.i().getAllLogsAsMaps();

      expect(logs, hasLength(1));

      expect(logs[0]['message'], contains('message with ***'));
    });

    test('without mask', () async {
      await TheLogger.i().init(
        retainStrategy: {Level.ALL: 100},
        startNewSession: false,
        maskDbLogger: false,
        sessionStartExtra: 'extra string',
      );
      await TheLogger.i().clearAllLogs();

      TheLogger.i().addMaskingString(MaskingString('password'));

      log.finest('message with password');

      final logs = await TheLogger.i().getAllLogsAsMaps();

      expect(logs, hasLength(1));

      expect(logs[0]['message'], contains('message with password'));
    });

    test('with multiple masks', () async {
      await TheLogger.i().init(
        retainStrategy: {Level.ALL: 100},
        startNewSession: false,
        sessionStartExtra: 'extra string',
      );
      await TheLogger.i().clearAllLogs();

      log.finest('msg0 with pwd, scr and seed');
      final logs0 = await TheLogger.i().getAllLogsAsMaps();
      expect(logs0[0]['message'], contains('msg0 with pwd, scr and seed'));

      TheLogger.i().addMaskingString(MaskingString('pwd'));
      log.finest('msg1 with pwd, scr and seed');
      final logs1 = await TheLogger.i().getAllLogsAsMaps();
      expect(logs1[1]['message'], contains('msg1 with ***, scr and seed'));

      TheLogger.i().addMaskingString(MaskingString('scr'));
      log.finest('msg2 with pwd, scr and seed');
      final logs2 = await TheLogger.i().getAllLogsAsMaps();
      expect(logs2[2]['message'], contains('msg2 with ***, *** and seed'));

      TheLogger.i().addMaskingString(MaskingString('seed'));
      log.finest('msg3 with pwd, scr and seed');
      final logs3 = await TheLogger.i().getAllLogsAsMaps();
      expect(logs3[3]['message'], contains('msg3 with ***, *** and ***'));

      TheLogger.i().removeMaskingString(MaskingString('scr'));
      log.finest('msg4 with pwd, scr and seed');
      final logs4 = await TheLogger.i().getAllLogsAsMaps();
      expect(logs4[4]['message'], contains('msg4 with ***, scr and ***'));

      TheLogger.i().clearMaskingStrings();
      log.finest('msg5 with pwd, scr and seed');
      final logs5 = await TheLogger.i().getAllLogsAsMaps();
      expect(logs5[5]['message'], contains('msg5 with pwd, scr and seed'));
    });
  });
}
