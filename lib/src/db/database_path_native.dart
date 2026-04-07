import 'dart:io';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Returns native database options that resolve to sqflite-compatible paths.
DriftNativeOptions? nativeDatabaseOptions(String name) {
  return DriftNativeOptions(
    databasePath: () => _resolveDatabasePath(name),
  );
}

// Matches sqflite's legacy path so existing databases are found on upgrade.
// Android: sqflite uses `<appData>/databases/`, not path_provider's
// `<appData>/app_flutter/`.
// iOS/macOS: both use the Documents directory — no mismatch.
Future<String> _resolveDatabasePath(String name) async {
  final documentsDir = await getApplicationDocumentsDirectory();
  if (Platform.isAndroid) {
    final dbDir = Directory(p.join(documentsDir.parent.path, 'databases'));
    await dbDir.create(recursive: true);
    return p.join(dbDir.path, name);
  }
  return p.join(documentsDir.path, name);
}
