import 'package:flutter_test/flutter_test.dart';
import 'package:gobarber/core/validation/validators.dart';

void main() {
  group('validateEmail', () {
    test('accepts normal addresses', () {
      expect(validateEmail('ali@example.com'), isNull);
      expect(validateEmail('  ali.b@mail.tn '), isNull);
    });
    test('rejects empty and malformed input', () {
      expect(validateEmail(''), FieldError.required);
      expect(validateEmail('   '), FieldError.required);
      expect(validateEmail('ali'), FieldError.invalidEmail);
      expect(validateEmail('ali@'), FieldError.invalidEmail);
      expect(validateEmail('a li@x.com'), FieldError.invalidEmail);
      expect(validateEmail('ali@x'), FieldError.invalidEmail);
    });
  });

  group('validatePassword (8+ chars, a letter and a digit)', () {
    test('accepts valid passwords', () {
      expect(validatePassword('Passw0rd'), isNull);
      expect(validatePassword('abcdefg1'), isNull);
      expect(validatePassword('12345678a'), isNull);
    });
    test('rejects short, letter-only and digit-only passwords', () {
      expect(validatePassword(''), FieldError.required);
      expect(validatePassword('Ab1'), FieldError.passwordTooShort);
      expect(validatePassword('abcdefgh'), FieldError.passwordWeak);
      expect(validatePassword('12345678'), FieldError.passwordWeak);
    });
    test('counts Arabic letters as letters', () {
      expect(validatePassword('كلمةالسر1'), isNull); // 8 Arabic letters + 1 digit
    });
  });

  group('validateName', () {
    test('requires at least 2 characters', () {
      expect(validateName(''), FieldError.required);
      expect(validateName('A'), FieldError.nameTooShort);
      expect(validateName(' Al '), isNull);
    });
  });
}
