/// Build-time configuration. Values come from `--dart-define` /
/// `--dart-define-from-file=env/dev.json` (the real env/*.json files are git-ignored),
/// so no secrets or credentials live in the source code.
class AppConfig {
  AppConfig._();

  static const environment = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  /// Phase 1 runs on in-memory demo data. Phase 3 switches this to false (Firebase).
  static const useMockData = bool.fromEnvironment('USE_MOCK_DATA', defaultValue: true);

  /// Filled in from env/*.json once Firebase is set up (Phase 2/3). Empty = not configured.
  static const firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static bool get firebaseConfigured => firebaseProjectId.isNotEmpty;
}
