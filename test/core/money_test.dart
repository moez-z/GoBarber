import 'package:flutter_test/flutter_test.dart';
import 'package:gobarber/core/format/money.dart';

void main() {
  group('formatTnd', () {
    test('always shows 3 decimals and the DT symbol (fr)', () {
      expect(formatTnd(35000, 'fr'), '35,000\u00A0DT');
      expect(formatTnd(12500, 'fr'), '12,500\u00A0DT');
      expect(formatTnd(0, 'fr'), '0,000\u00A0DT');
      expect(formatTnd(5, 'fr'), '0,005\u00A0DT');
    });
    test('groups thousands', () {
      expect(formatTnd(1234567, 'fr'), '1\u00A0234,567\u00A0DT');
    });
    test('uses the Arabic symbol with Latin digits (ar)', () {
      expect(formatTnd(35000, 'ar'), '35,000\u00A0د.ت');
    });
    test('negative amounts', () {
      expect(formatTnd(-500, 'fr'), '-0,500\u00A0DT');
    });
  });

  group('parseTndToMillimes', () {
    test('accepts comma or dot decimals', () {
      expect(parseTndToMillimes('35'), 35000);
      expect(parseTndToMillimes('12,5'), 12500);
      expect(parseTndToMillimes('12.500'), 12500);
      expect(parseTndToMillimes(' 1 250 '), 1250000);
    });
    test('accepts Arabic-Indic digits', () {
      expect(parseTndToMillimes('٣٥'), 35000);
    });
    test('rejects invalid input', () {
      expect(parseTndToMillimes(''), isNull);
      expect(parseTndToMillimes('abc'), isNull);
      expect(parseTndToMillimes('1.2345'), isNull);
      expect(parseTndToMillimes('-5'), isNull);
    });
  });

  test('latinDigits converts Arabic-Indic and Persian digits', () {
    expect(latinDigits('١٢٣ ۴۵۶ abc 789'), '123 456 abc 789');
  });
}
