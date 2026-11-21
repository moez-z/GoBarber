import 'package:gobarber/core/validation/validators.dart';
import 'package:gobarber/l10n/app_localizations.dart';

String fieldErrorText(AppLocalizations l, FieldError e) => switch (e) {
      FieldError.required => l.fieldRequired,
      FieldError.invalidEmail => l.fieldInvalidEmail,
      FieldError.nameTooShort => l.fieldNameShort,
      FieldError.passwordTooShort => l.fieldPasswordShort,
      FieldError.passwordWeak => l.fieldPasswordWeak,
    };
