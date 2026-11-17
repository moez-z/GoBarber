import 'package:flutter/material.dart';

/// Language chosen by the user. `null` = follow the device (falls back to French).
/// Not persisted yet (persistence is added together with user profiles in Phase 2).
class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void set(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
