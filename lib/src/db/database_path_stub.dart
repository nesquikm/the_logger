import 'package:drift_flutter/drift_flutter.dart';

/// Returns null on web — drift_flutter handles web storage automatically.
DriftNativeOptions? nativeDatabaseOptions(String name) => null;
