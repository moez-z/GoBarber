import 'package:gobarber/l10n/app_localizations.dart';

enum ErrorCode { wrongCredentials, invalidInput, slotTaken, unknown }

/// Domain error thrown by repositories. The UI turns the [code] into a localized message.
class AppException implements Exception {
  const AppException(this.code);
  final ErrorCode code;
  @override
  String toString() => 'AppException($code)';
}

String errorText(AppLocalizations l, ErrorCode code) => switch (code) {
      ErrorCode.wrongCredentials => l.errWrongCredentials,
      ErrorCode.invalidInput => l.errInvalidInput,
      ErrorCode.slotTaken => l.errSlotTaken,
      ErrorCode.unknown => l.errUnknown,
    };
