import 'dart:convert';
import 'dart:math';

/// Extension for strings.
extension StringExtensions on String {
  /// Try to format embedded JSON in a string.
  String get prettyJson {
    final start = <int>[];
    final end = <int>[];
    var depth = 0;
    for (var i = 0; i < length; i++) {
      if (this[i] == '{') {
        if (depth == 0) {
          start.add(i);
        }
        depth++;
      }
      if (this[i] == '}' && start.length > end.length) {
        depth--;
        if (depth == 0) {
          end.add(i);
        }
      }
    }

    final substrings = <(int, int, bool)>[];
    var prev = 0;
    for (var i = 0; i < min(start.length, end.length); i++) {
      substrings
        ..add((prev, start[i], false))
        ..add((start[i], end[i] + 1, true));
      prev = end[i] + 1;
    }

    substrings
      ..add((prev, length, false))
      ..removeWhere((tuple) => tuple.$1 == tuple.$2);

    final buffer = StringBuffer();

    for (var i = 0; i < substrings.length; i++) {
      final sub = substring(substrings[i].$1, substrings[i].$2);
      final form = _tryToFormatJson(sub);

      buffer.write(form);
    }

    return buffer.toString();
  }

  String _tryToFormatJson(String json) {
    try {
      return '''\n  ${_jsonEncoder.convert(jsonDecode(json)).replaceAll('\n', '\n  ')}\n''';
    } catch (e) {
      return json;
    }
  }

  static const _jsonEncoder = JsonEncoder.withIndent('  ');
}
