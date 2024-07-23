import 'package:flutter/foundation.dart';

/// A class that masks a string by replacing all occurrences of a given string
@immutable
class MaskingString {
  /// Create a [MaskingString] instance.
  MaskingString(
    this.from, {
    this.caseSensitive = true,
    this.maskedString = _defaultMaskedString,
    bool isRegExp = false,
  }) : _regExp = RegExp(
          isRegExp ? from : RegExp.escape(from),
          caseSensitive: caseSensitive,
        );

  /// The string to search for in the source string.
  final String from;

  /// Whether the search for the [from] string is case sensitive.
  final bool caseSensitive;

  /// What to replace the [from] string with.
  final String maskedString;

  static const String _defaultMaskedString = '***';
  final RegExp _regExp;

  /// Mask the input string.
  String mask(String input) => input.replaceAll(_regExp, maskedString);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaskingString &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          caseSensitive == other.caseSensitive &&
          maskedString == other.maskedString);

  @override
  int get hashCode =>
      from.hashCode ^ caseSensitive.hashCode ^ maskedString.hashCode;
}
