import 'package:logging/logging.dart';

/// An abstract logger
abstract class AbstractLogger {
  /// Init logger
  Future<void> init(Map<Level, int> retainStrategy) async {}

  /// Start a new session
  /// It can return string with session id
  Future<String?> sessionStart() async {
    return null;
  }

  /// Write record
  void write(LogRecord record);
}
