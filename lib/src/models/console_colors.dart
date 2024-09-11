// ignore_for_file: public_member_api_docs

/// ANSI escape codes
enum DefaultConsoleColor {
  /// Reset
  reset('\x1B[0m'),

  /// 256 colors
  red0('\x1B[38;5;200m'),
  red1('\x1B[38;5;196m'),
  green0('\x1B[38;5;40m'),
  green1('\x1B[38;5;43m'),
  green2('\x1B[38;5;45m'),
  yellow0('\x1B[38;5;184m'),
  blue0('\x1B[38;5;137m'),
  blue1('\x1B[38;5;145m');

  const DefaultConsoleColor(this.value);
  final String value;
}

/// Console logger colors
class ConsoleColors {
  /// Default console colors
  const ConsoleColors();
  String get finest => DefaultConsoleColor.green0.value;
  String get finer => DefaultConsoleColor.green1.value;
  String get fine => DefaultConsoleColor.green2.value;
  String get config => DefaultConsoleColor.blue0.value;
  String get info => DefaultConsoleColor.blue1.value;
  String get warning => DefaultConsoleColor.yellow0.value;
  String get severe => DefaultConsoleColor.red0.value;
  String get shout => DefaultConsoleColor.red1.value;
  String get reset => DefaultConsoleColor.reset.value;
}
