/// Build-time configuration. Values come from `--dart-define` /
/// `--dart-define-from-file=env/dev.json` (the real env/*.json files are git-ignored),
/// so no secrets or credentials live in the source code.
class AppConfig {
  AppConfig._();

  static const environment = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  /// Phase 1 runs on in-memory demo data. Phase 3 switches this to false (Firebase).
  static const useMockData = bool.fromEnvironment('USE_MOCK_DATA', defaultValue: true);

  /// Firebase project the app must be configured for. The id is public (it appears in the
  /// project's URLs), so a default is fine; it exists to catch a wrong/mixed-up
  /// firebase_options.dart. Override with --dart-define=FIREBASE_PROJECT_ID=... if needed.
  static const firebaseProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'barbershop-7b59b');
  static bool get firebaseConfigured => firebaseProjectId.isNotEmpty;
}
