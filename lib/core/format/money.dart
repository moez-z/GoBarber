/// Money is stored as integer millimes (1 TND = 1000 millimes) to avoid floating point errors.
const _nbsp = '\u00A0';

/// Converts Arabic-Indic / Persian digits to Latin digits (Tunisia uses Latin digits).
String latinDigits(String s) {
  final b = StringBuffer();
  for (final r in s.runes) {
    if (r >= 0x0660 && r <= 0x0669) {
      b.writeCharCode(0x30 + r - 0x0660);
    } else if (r >= 0x06F0 && r <= 0x06F9) {
      b.writeCharCode(0x30 + r - 0x06F0);
    } else {
      b.writeCharCode(r);
    }
  }
  return b.toString();
}

/// 35000 -> "35,000 DT" (fr) / "35,000 د.ت" (ar). Always 3 decimals, as is standard for TND.
String formatTnd(int millimes, String languageCode) {
  final abs = millimes.abs();
  final whole = (abs ~/ 1000).toString();
  final frac = (abs % 1000).toString().padLeft(3, '0');
  final grouped = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) grouped.write(_nbsp);
    grouped.write(whole[i]);
  }
  final symbol = languageCode == 'ar' ? 'د.ت' : 'DT';
  return '${millimes < 0 ? '-' : ''}$grouped,$frac$_nbsp$symbol';
}

/// Parses user input such as "35", "12,5" or "12.500" into millimes. Returns null if invalid.
int? parseTndToMillimes(String input) {
  final s = latinDigits(input).replaceAll(RegExp(r'[\s\u00A0]'), '').replaceAll(',', '.');
  final m = RegExp(r'^(\d{1,9})(?:\.(\d{1,3}))?$').firstMatch(s);
  if (m == null) return null;
  final whole = int.parse(m.group(1)!);
  final frac = int.parse((m.group(2) ?? '').padRight(3, '0'));
  return whole * 1000 + frac;
}
