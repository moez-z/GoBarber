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

## Demo mode (Phase 1 only)
Data is in memory and resets on restart. The login screen has one-tap demo accounts, and the mock sign-in
**does not check passwords** (none are stored). It is for development only and is replaced by Firebase Auth in Phase 2.
Demo e-mails: customer@, marcus@ (employee), owner@, ceo@ + `gobarber.com`.
