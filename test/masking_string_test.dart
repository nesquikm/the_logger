import 'package:flutter_test/flutter_test.dart';
import 'package:the_logger/src/models/models.dart';

void main() {
  group('MaskingString', () {
    test('plain text replace', () {
      final maskingStrings = MaskingString('password');
      expect(
        maskingStrings.mask('hellopassword_passWord'),
        'hello***_passWord',
      );
    });

    test('plain text replace case insensitive', () {
      final maskingStrings = MaskingString('password', caseSensitive: false);
      expect(
        maskingStrings.mask('hellopassword_passWord'),
        'hello***_***',
      );
    });

    test('plain text replace custom mask string', () {
      final maskingStrings = MaskingString('password', maskedString: '####');
      expect(
        maskingStrings.mask('hellopassword_passWord'),
        'hello####_passWord',
      );
    });

    test('regexp replace', () {
      final maskingStrings = MaskingString('pa[a-zA-Z]+rd', isRegExp: true);
      expect(
        maskingStrings.mask('hellopassword_passWord'),
        'hello***_***',
      );
    });
  });
}
