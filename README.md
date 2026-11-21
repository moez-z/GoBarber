# GoBarber (Flutter)

Roles: **customer**, **employee** (barber), **owner** (shop owner), **platformAdmin** (CEO).
Languages: French and Tunisian Arabic (derja, RTL). Currency: TND (stored as millimes).

## Run
```bash
flutter pub get
flutter gen-l10n            # generates lib/l10n/app_localizations*.dart
flutter run                 # or: flutter run -d chrome
```
Optional config (never commit real values; `env/*.json` is git-ignored):
```bash
copy env\dev.example.json env\dev.json
flutter run --dart-define-from-file=env/dev.json
```

## Firebase (project `barbershop-7b59b`, Spark plan)
`lib/firebase_options.dart` and `android/app/google-services.json` are generated and git-ignored.
After a fresh clone run once:
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=barbershop-7b59b --platforms=android,web --android-package-name=tn.gobarber.app
```
Firebase is initialized at startup (`lib/core/firebase/firebase_bootstrap.dart`). In debug builds the log shows
`Firebase initialized: project=barbershop-7b59b` and a Firestore probe that must report
`permission-denied` (rules locked). The app still runs on mock data until Phase 2.2.

## Check
```bash
flutter analyze
flutter test
flutter build apk --debug
```

## Structure
- `lib/core` config, errors, formatting (TND/date), theme, shared widgets, availability logic
- `lib/models` plain data classes (no passwords anywhere)
- `lib/data` repository interfaces + in-memory demo implementation (Firebase comes in Phase 2/3)
- `lib/providers` one ChangeNotifier per concern (auth, catalog, appointments, locale)
- `lib/features` screens per role
- `lib/l10n` ARB translation files (fr, ar)

## Authentication (Phase 2.2)
Real Firebase e-mail/password sign-in, registration (customers only), password reset, e-mail verification
reminder and persistent sessions. Passwords: 8+ characters with a letter and a digit. Every real account is a
**customer** until the Firestore role profiles arrive in Phase 2.3. Owner registration comes in Phase 2.4.

## Demo mode (debug builds only)
One-tap demo accounts appear on the login screen only in Flutter **debug** builds (`AppConfig.demoEnabled` is
`kDebugMode && ENABLE_DEMO`, a compile-time constant, so release builds cannot enable it). Demo users have no
Firebase identity and no password: they only see in-memory demo data and can never access real Firestore data.
Disable them in debug with `--dart-define=ENABLE_DEMO=false`. Catalog and appointments are still in-memory until Phase 3.
