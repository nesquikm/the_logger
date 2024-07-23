import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:the_logger/src/models/models.dart';

void main() {
  group('WritableLogRecord extension for MaskedLogRecord', () {
    test('to map', () {
      final map = MaskedLogRecord.fromLogRecordFields(
        Level.CONFIG,
        'msg12',
        'logger34',
        'some error',
        StackTrace.fromString('some stacktrace'),
        null,
        null,
      ).toMap(sessionId: 42, mask: false);
      expect(map, {
        'session_id': 42,
        'level': Level.CONFIG.value,
        'message': 'msg12',
        'logger_name': 'logger34',
        'error': 'some error',
        'stack_trace': 'some stacktrace',
        'time': map['time'], // can't check it really
      });
    });

    test('from map', () {
      final originalMap = {
        'session_id': 42,
        'level': Level.CONFIG.value,
        'message': 'msg12',
        'error': 'some error',
        'stack_trace': 'some stacktrace',
        'logger_name': 'logger34',
      };

      final convertedMap = WritableLogRecord.fromMap(originalMap)
          .toMap(sessionId: 42, mask: false);

      expect(convertedMap, {...originalMap, 'time': convertedMap['time']});
    });
  });

  group('WritableLogRecord extension for MaskedLogRecord, with mask', () {
    test('to map', () {
      final map = MaskedLogRecord.fromLogRecordFields(
        Level.CONFIG,
        'msg12passwordandsecret',
        'logger34',
        'some error passwordandsecret',
        StackTrace.fromString('some stacktrace passwordandsecret'),
        null,
        null,
        maskingStrings: {
          MaskingString('password'),
          MaskingString('secret'),
        },
      ).toMap(sessionId: 42, mask: true);
      expect(map, {
        'session_id': 42,
        'level': Level.CONFIG.value,
        'message': 'msg12***and***',
        'logger_name': 'logger34',
        'error': 'some error ***and***',
        'stack_trace': 'some stacktrace ***and***',
        'time': map['time'], // can't check it really
      });
    });

    test('from map', () {
      final originalMap = {
        'session_id': 42,
        'level': Level.CONFIG.value,
        'message': 'msg12passwordandsecret',
        'error': 'some error passwordandsecret',
        'stack_trace': 'some stacktrace passwordandsecret',
        'logger_name': 'logger34',
      };

      final fromMap = WritableLogRecord.fromMap(
        originalMap,
        maskingStrings: {
          MaskingString('password'),
          MaskingString('secret'),
        },
      );

      final convertedMap = fromMap.toMap(sessionId: 42, mask: true);

      expect(convertedMap, {
        ...originalMap,
        'time': convertedMap['time'],
        'message': 'msg12***and***',
        'error': 'some error ***and***',
        'stack_trace': 'some stacktrace ***and***',
      });
    });
  });
}
