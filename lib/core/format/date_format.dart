import 'package:intl/intl.dart';
import 'package:gobarber/core/format/money.dart';
import 'package:gobarber/l10n/app_localizations.dart';

/// 24-hour time with Latin digits, e.g. "14:30" (the usual format in Tunisia).
String hm(DateTime d) => DateFormat('HH:mm', 'en').format(d);

/// Locale-aware date text (day/month names follow [lang]) with Latin digits.
String fmtDate(String pattern, DateTime d, String lang) =>
    latinDigits(DateFormat(pattern, lang).format(d));

/// "Today, 14:30" / "Tomorrow, 10:00" / "Tue 15 Oct, 14:30" in the current language.
String whenLabel(AppLocalizations l, DateTime d) {
  final n = DateTime.now();
  final diff = DateTime.utc(d.year, d.month, d.day)
      .difference(DateTime.utc(n.year, n.month, n.day))
      .inDays;
  final t = hm(d);
  if (diff == 0) return l.whenToday(t);
  if (diff == 1) return l.whenTomorrow(t);
  return l.whenOther(fmtDate('EEE d MMM', d, l.localeName), t);
}
