// ignore_for_file: public_member_api_docs

/// ANSI escape codes
enum ConsoleColor {
  /// Reset
  reset('\x1B[0m'),

  /// 8 colors
  black('\x1B[30m'),
  white('\x1B[37m'),
  red('\x1B[31m'),
  green('\x1B[32m'),
  yellow('\x1B[33m'),
  blue('\x1B[34m'),
  cyan('\x1B[36m'),

  /// 256 colors
  red0('\x1B[38;5;200m'),
  red1('\x1B[38;5;196m'),
  green0('\x1B[38;5;40m'),
  green1('\x1B[38;5;43m'),
  green2('\x1B[38;5;45m'),
  yellow0('\x1B[38;5;184m'),
  blue0('\x1B[38;5;137m'),
  blue1('\x1B[38;5;145m');

  const ConsoleColor(this.value);
  final String value;
}
