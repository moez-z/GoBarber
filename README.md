# GoBarber (Flutter)

Roles: **customer** (browse barbers, book free slots, cancel/rebook), **barber** (daily timeline, check-in/complete/cancel),
**admin** (overview, manage barbers & services).

## Run
```bash
flutter create gobarber          # generates android/ios/web folders
# copy this project's lib/ and pubspec.yaml over the generated ones
cd gobarber && flutter pub get && flutter run
```

## Demo logins
- customer@gobarber.com / customer123
- marcus@gobarber.com / barber123  (also devon@gobarber.com)
- admin@gobarber.com / admin123

Data is in memory (lib/store.dart) and resets on restart. Replace the Store methods with Firebase/Supabase/REST calls to persist.
