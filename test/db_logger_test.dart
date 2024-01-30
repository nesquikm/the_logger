import 'dart:convert';
import 'dart:io' show Platform;

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
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

  group('TheLogger db tests', () {
    test('init and check empty', () async {
      await TheLogger.i().init(
        startNewSession: false,
      );
      await TheLogger.i().clearAllLogs();
      expect(await TheLogger.i().getAllLogsAsString(), isEmpty);
    });

    test('add session and all log levels', () async {
      await TheLogger.i().init(
        retainStrategy: {Level.ALL: 100},
        startNewSession: false,
      );
      await TheLogger.i().clearAllLogs();

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

      final logs = await TheLogger.i().getAllLogsAsMaps();

      expect(logs, hasLength(9));

      final sessionId = logs[0]['session_id'];
      expect(logs[0]['level'], Level.INFO.value);
      expect(logs[0]['message'], 'Session start new session id: $sessionId');
      expect(logs[0]['logger_name'], 'TheLogger');

      expect(logs[1]['id'], (logs[0]['id']! as int) + 1);
      expect(logs[1]['session_id'], sessionId);
      expect(logs[1]['level'], Level.FINEST.value);
      expect(logs[1]['message'], 'some finest log');
      expect(logs[1]['logger_name'], 'TestLogger');

      expect(logs[2]['id'], (logs[1]['id']! as int) + 1);
      expect(logs[2]['session_id'], sessionId);
      expect(logs[2]['level'], Level.FINER.value);
      expect(logs[2]['message'], 'some finer log');
      expect(logs[2]['logger_name'], 'TestLogger');

      expect(logs[3]['id'], (logs[2]['id']! as int) + 1);
      expect(logs[3]['session_id'], sessionId);
      expect(logs[3]['level'], Level.FINE.value);
      expect(logs[3]['message'], 'some fine log');
      expect(logs[3]['logger_name'], 'TestLogger');

      expect(logs[4]['id'], (logs[3]['id']! as int) + 1);
      expect(logs[4]['session_id'], sessionId);
      expect(logs[4]['level'], Level.CONFIG.value);
      expect(logs[4]['message'], 'some config log');
      expect(logs[4]['logger_name'], 'TestLogger');

      expect(logs[5]['id'], (logs[4]['id']! as int) + 1);
      expect(logs[5]['session_id'], sessionId);
      expect(logs[5]['level'], Level.INFO.value);
      expect(logs[5]['message'], 'some info log');
      expect(logs[5]['logger_name'], 'TestLogger');

      expect(logs[6]['id'], (logs[5]['id']! as int) + 1);
      expect(logs[6]['session_id'], sessionId);
      expect(logs[6]['level'], Level.WARNING.value);
      expect(logs[6]['message'], 'some warning log');
      expect(logs[6]['logger_name'], 'TestLogger');

      expect(logs[7]['id'], (logs[6]['id']! as int) + 1);
      expect(logs[7]['session_id'], sessionId);
      expect(logs[7]['level'], Level.SEVERE.value);
      expect(logs[7]['message'], 'some severe log');
      expect(logs[7]['logger_name'], 'TestLogger');

      expect(logs[8]['id'], (logs[7]['id']! as int) + 1);
      expect(logs[8]['session_id'], sessionId);
      expect(logs[8]['level'], Level.SHOUT.value);
      expect(logs[8]['message'], 'some shout log');
      expect(logs[8]['logger_name'], 'TestLogger');
    });

    test('add session with extra string', () async {
      await TheLogger.i().init(
        retainStrategy: {Level.ALL: 100},
        startNewSession: false,
        sessionStartExtra: 'extra string',
      );
      await TheLogger.i().clearAllLogs();

      await TheLogger.i().startSession();

      final logs = await TheLogger.i().getAllLogsAsMaps();

      expect(logs, hasLength(1));

      final sessionId = logs[0]['session_id'];
      expect(logs[0]['level'], Level.INFO.value);
      expect(
        logs[0]['message'],
        'Session start new session id: $sessionId extra string',
      );
      expect(logs[0]['logger_name'], 'TheLogger');
    });

    test('add session with stack trace', () async {
      await TheLogger.i().init(
        retainStrategy: {Level.ALL: 100},
        startNewSession: false,
        sessionStartExtra: 'extra string',
      );
      await TheLogger.i().clearAllLogs();

      await TheLogger.i().startSession();

      try {
        throw Exception('some exception');
      } catch (e, s) {
        log.severe(e, 'some error', s);
      }

      final logs = await TheLogger.i().getAllLogsAsMaps();

      expect(logs, hasLength(2));

      expect(logs[1]['message'], contains('some exception'));
      expect(logs[1]['error'], contains('some error'));
      expect(
        logs[1]['stack_trace'].toString(),
        contains('the_logger/test/db_logger_test'),
      );
    });

    test('test retain strategy', () async {
      await TheLogger.i().init(
        retainStrategy: {
          Level.FINEST: 1,
          Level.FINER: 1,
          Level.FINE: 1,
          Level.CONFIG: 1,
          Level.INFO: 1,
          Level.WARNING: 1,
          Level.SEVERE: 1,
          Level.SHOUT: 1,
        },
        startNewSession: false,
      );
      await TheLogger.i().clearAllLogs();

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

      var logs = (await TheLogger.i().getAllLogsAsMaps()).where(
        (element) => !(element['message']! as String).contains('Session start'),
      );
      expect(
        logs,
        hasLength(8),
      );

      await Future.delayed(const Duration(milliseconds: 500), () {});
      logs = (await TheLogger.i().getAllLogsAsMaps()).where(
        (element) => !(element['message']! as String).contains('Session start'),
      );
      expect(
        logs,
        hasLength(8),
      );

      for (var i = 8; i >= 0; i--) {
        await TheLogger.i().startSession();
        await Future.delayed(const Duration(milliseconds: 500), () {});
        logs = (await TheLogger.i().getAllLogsAsMaps()).where(
          (element) =>
              !(element['message']! as String).contains('Session start'),
        );
        expect(
          logs,
          hasLength(i),
        );
      }
    });
  });

  group('TheLogger db export tests', () {
    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });
    test('archived JSON test', () async {
      await TheLogger.i().init(
        retainStrategy: {Level.ALL: 100},
        startNewSession: false,
      );
      await TheLogger.i().clearAllLogs();

      const sessionCount = 16;
      const logsCount = 16;

      for (var i = 0; i < sessionCount; i++) {
        await TheLogger.i().startSession();
        for (var j = 0; j < logsCount; j++) {
          log
            ..finest('some finest log')
            ..finer('some finer log')
            ..fine('some fine log')
            ..config('some config log')
            ..info('some info log')
            ..warning('some warning log')
            ..severe('some severe log')
            ..shout(
              'some shout log',
              'some shout error',
              StackTrace.fromString('some shout stacktrace'),
            );
        }
      }

      final archive = await TheLogger.i().writeAllLogsToJson();

      final input = InputFileStream(archive);
      final jsonContent =
          json.decode(utf8.decode(BZip2Decoder().decodeBuffer(input)))
              as Map<String, dynamic>;
      final logs = jsonContent['logs'] as List<dynamic>;

      var index = 0;
      var prevSessionId = -1;
      var id = (logs[0] as Map<String, dynamic>)['id'] as int;
      for (var i = 0; i < sessionCount; i++) {
        final logSession = logs[index++] as Map<String, dynamic>;
        expect(logSession['logger_name'], 'TheLogger');

        final sessionId = logSession['session_id'] as int;
        expect(sessionId, greaterThan(prevSessionId));
        prevSessionId = sessionId;

        expect(logSession['level'], Level.INFO.value);

        expect(
          logSession['message'],
          'Session start new session id: $sessionId',
        );

        expect(logSession['id'], id++);

        for (var j = 0; j < logsCount; j++) {
          final logFinest = logs[index++] as Map<String, dynamic>;
          final logFiner = logs[index++] as Map<String, dynamic>;
          final logFine = logs[index++] as Map<String, dynamic>;
          final logConfig = logs[index++] as Map<String, dynamic>;
          final logInfo = logs[index++] as Map<String, dynamic>;
          final logWarning = logs[index++] as Map<String, dynamic>;
          final logSevere = logs[index++] as Map<String, dynamic>;
          final logShout = logs[index++] as Map<String, dynamic>;

          expect(logFinest['logger_name'], 'TestLogger');
          expect(logFinest['session_id'], sessionId);
          expect(logFinest['level'], Level.FINEST.value);
          expect(logFinest['message'], 'some finest log');
          expect(logFinest['id'], id++);

          expect(logFiner['logger_name'], 'TestLogger');
          expect(logFiner['session_id'], sessionId);
          expect(logFiner['level'], Level.FINER.value);
          expect(logFiner['message'], 'some finer log');
          expect(logFiner['id'], id++);

          expect(logFine['logger_name'], 'TestLogger');
          expect(logFine['session_id'], sessionId);
          expect(logFine['level'], Level.FINE.value);
          expect(logFine['message'], 'some fine log');
          expect(logFine['id'], id++);

          expect(logConfig['logger_name'], 'TestLogger');
          expect(logConfig['session_id'], sessionId);
          expect(logConfig['level'], Level.CONFIG.value);
          expect(logConfig['message'], 'some config log');
          expect(logConfig['id'], id++);

          expect(logInfo['logger_name'], 'TestLogger');
          expect(logInfo['session_id'], sessionId);
          expect(logInfo['level'], Level.INFO.value);
          expect(logInfo['message'], 'some info log');
          expect(logInfo['id'], id++);

          expect(logWarning['logger_name'], 'TestLogger');
          expect(logWarning['session_id'], sessionId);
          expect(logWarning['level'], Level.WARNING.value);
          expect(logWarning['message'], 'some warning log');
          expect(logWarning['id'], id++);

          expect(logSevere['logger_name'], 'TestLogger');
          expect(logSevere['session_id'], sessionId);
          expect(logSevere['level'], Level.SEVERE.value);
          expect(logSevere['message'], 'some severe log');
          expect(logSevere['id'], id++);

          expect(logShout['logger_name'], 'TestLogger');
          expect(logShout['session_id'], sessionId);
          expect(logShout['level'], Level.SHOUT.value);
          expect(logShout['message'], 'some shout log');
          expect(logShout['error'], 'some shout error');
          expect(logShout['stack_trace'], 'some shout stacktrace');
          expect(logShout['id'], id++);
        }
      }
      expect(logs, hasLength(index));
    });

    test('archived JSON test with custom filename', () async {
      await TheLogger.i().init(
        retainStrategy: {Level.ALL: 100},
        startNewSession: false,
      );
      await TheLogger.i().clearAllLogs();

      log
        ..finest('some finest log')
        ..finer('some finer log')
        ..fine('some fine log')
        ..config('some config log')
        ..info('some info log')
        ..warning('some warning log')
        ..severe('some severe log')
        ..shout('some shout log');

      final archive =
          await TheLogger.i().writeAllLogsToJson('custom_file_name');

      final input = InputFileStream(archive);
      final jsonContent =
          json.decode(utf8.decode(BZip2Decoder().decodeBuffer(input)))
              as Map<String, dynamic>;
      final logs = jsonContent['logs'] as List<dynamic>;

      expect(logs, hasLength(8));

      expect(archive, endsWith('custom_file_name.bz2'));
    });
  });
}

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getApplicationSupportPath() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getDownloadsPath() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>?> getExternalCachePaths() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getExternalStoragePath() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> getLibraryPath() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getTemporaryPath() async {
    return Platform.environment['TMPDIR'];
  }
}
