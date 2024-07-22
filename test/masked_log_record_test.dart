import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:the_logger/src/models/models.dart';

void main() {
  group('MaskedLogRecord', () {
    test('default constructor', () {
      final plainRecord = LogRecord(Level.INFO, 'msg', 'logger');

      final zone = Zone.current;
      const object = 'an object';
      final record = MaskedLogRecord(
        Level.INFO,
        'msg12passwordandsecret',
        'logger34',
        'some error passwordandsecret',
        StackTrace.fromString('some stacktrace passwordandsecret'),
        zone,
        object,
        maskedMessage: 'msg12***and***',
        maskedError: 'some error ***and***',
        maskedStackTrace: 'some stacktrace ***and***',
      );

      expect(record.level, Level.INFO);
      expect(record.message, 'msg12passwordandsecret');
      expect(record.loggerName, 'logger34');
      expect(record.error, 'some error passwordandsecret');
      expect(
        record.stackTrace.toString(),
        'some stacktrace passwordandsecret',
      );
      expect(record.zone, zone);
      expect(record.object, object);
      expect(record.maskedMessage, 'msg12***and***');
      expect(record.maskedError, 'some error ***and***');
      expect(record.maskedStackTrace, 'some stacktrace ***and***');
      expect(DateTime.now().difference(record.time).inSeconds, lessThan(1));
      expect(record.sequenceNumber, greaterThan(plainRecord.sequenceNumber));
    });

    test('fromLogRecordFields', () {
      final zone = Zone.current;
      const object = 'an object';
      final record = MaskedLogRecord.fromLogRecordFields(
        Level.INFO,
        'msg12passwordandsecret',
        'logger34',
        'some error passwordandsecret',
        StackTrace.fromString('some stacktrace passwordandsecret'),
        zone,
        object,
        maskingStrings: {
          MaskingString('password'),
          MaskingString('secret'),
        },
      );

      expect(record.level, Level.INFO);
      expect(record.message, 'msg12passwordandsecret');
      expect(record.loggerName, 'logger34');
      expect(record.error, 'some error passwordandsecret');
      expect(
        record.stackTrace.toString(),
        'some stacktrace passwordandsecret',
      );
      expect(record.zone, zone);
      expect(record.object, object);
      expect(record.maskedMessage, 'msg12***and***');
      expect(record.maskedError, 'some error ***and***');
      expect(record.maskedStackTrace, 'some stacktrace ***and***');
    });
  });

  test('fromLogRecord', () {
    final zone = Zone.current;
    const object = 'an object';
    final record = MaskedLogRecord.fromLogRecord(
      LogRecord(
        Level.INFO,
        'msg12passwordandsecret',
        'logger34',
        'some error passwordandsecret',
        StackTrace.fromString('some stacktrace passwordandsecret'),
        zone,
        object,
      ),
      maskingStrings: {
        MaskingString('password'),
        MaskingString('secret'),
      },
    );

    expect(record.level, Level.INFO);
    expect(record.message, 'msg12passwordandsecret');
    expect(record.loggerName, 'logger34');
    expect(record.error, 'some error passwordandsecret');
    expect(
      record.stackTrace.toString(),
      'some stacktrace passwordandsecret',
    );
    expect(record.zone, zone);
    expect(record.object, object);
    expect(record.maskedMessage, 'msg12***and***');
    expect(record.maskedError, 'some error ***and***');
    expect(record.maskedStackTrace, 'some stacktrace ***and***');
  });
}
