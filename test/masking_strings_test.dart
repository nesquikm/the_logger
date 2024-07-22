import 'package:flutter_test/flutter_test.dart';
import 'package:the_logger/src/models/models.dart';

void main() {
  group('MaskingStrings', () {
    test('empty', () {
      final maskingStrings = <MaskingString>{};
      expect(
        maskingStrings.mask('hellopassword_passWord'),
        'hellopassword_passWord',
      );
    });

    test('multiple', () {
      final maskingStrings = <MaskingString>{
        MaskingString('password'),
        MaskingString('hello'),
      };
      expect(
        maskingStrings.mask('hellopassword_passWord'),
        '******_passWord',
      );
    });
  });
}
