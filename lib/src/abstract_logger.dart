import 'package:logging/logging.dart';

import 'package:the_logger/src/models/models.dart';

/// An abstract logger
abstract class AbstractLogger {
  /// Init logger
  Future<void> init(Map<Level, int> retainStrategy) async {}

  /// Start a new session, it can return string with session id
  Future<String?> sessionStart() async {
    return null;
  }

  /// Write record
  void write(MaskedLogRecord record);
}
