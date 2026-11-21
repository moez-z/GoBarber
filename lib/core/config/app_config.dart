import 'package:flutter/foundation.dart';

/// Build-time configuration. Values come from `--dart-define` /
/// `--dart-define-from-file=env/dev.json` (the real env/*.json files are git-ignored),
/// so no secrets or credentials live in the source code.
class AppConfig {
  AppConfig._();

  static const environment = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  /// Catalog/appointment data still runs on in-memory demo data until Phase 3 (Firestore).
  static const useMockData = bool.fromEnvironment('USE_MOCK_DATA', defaultValue: true);

  /// One-tap demo accounts. `kDebugMode` is a compile-time constant, so in release/profile
  /// builds this is `false` and no define can switch it on.
  static const demoEnabled = kDebugMode && bool.fromEnvironment('ENABLE_DEMO', defaultValue: true);

  /// Firebase project the app must be configured for. The id is public (it appears in the
  /// project's URLs), so a default is fine; it exists to catch a wrong/mixed-up
  /// firebase_options.dart. Override with --dart-define=FIREBASE_PROJECT_ID=... if needed.
  static const firebaseProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'barbershop-7b59b');
  static bool get firebaseConfigured => firebaseProjectId.isNotEmpty;
}
