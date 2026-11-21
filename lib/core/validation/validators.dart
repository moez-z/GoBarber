/// Form validation shared by the UI and the auth repository (defense in depth).
enum FieldError { required, invalidEmail, nameTooShort, passwordTooShort, passwordWeak }

final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');
final _letter = RegExp(r'\p{L}', unicode: true);
final _digit = RegExp(r'\p{Nd}', unicode: true);

FieldError? validateEmail(String v) {
  final e = v.trim();
  if (e.isEmpty) return FieldError.required;
  return _emailRe.hasMatch(e) ? null : FieldError.invalidEmail;
}

FieldError? validateName(String v) {
  final n = v.trim();
  if (n.isEmpty) return FieldError.required;
  return n.length < 2 ? FieldError.nameTooShort : null;
}

/// Registration policy: at least 8 characters, with at least one letter and one digit.
FieldError? validatePassword(String v) {
  if (v.isEmpty) return FieldError.required;
  if (v.length < 8) return FieldError.passwordTooShort;
  if (!_letter.hasMatch(v) || !_digit.hasMatch(v)) return FieldError.passwordWeak;
  return null;
}
