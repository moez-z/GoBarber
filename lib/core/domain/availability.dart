import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/models/barber.dart';

bool overlaps(DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) =>
    aStart.isBefore(bEnd) && aEnd.isAfter(bStart);

/// True when no non-cancelled appointment of [barberId] overlaps [start, start+minutes).
bool isFree(Iterable<Appointment> existing, String barberId, DateTime start, int minutes) {
  final end = start.add(Duration(minutes: minutes));
  return !existing.any((a) =>
      a.barberId == barberId &&
      a.status != Status.cancelled &&
      overlaps(start, end, a.start, a.end));
}

/// Free start times on a 30-minute grid inside the barber's opening hours.
List<DateTime> freeSlots({
  required Barber barber,
  required DateTime day,
  required int minutes,
  required Iterable<Appointment> existing,
  required DateTime now,
}) {
  final d = DateTime(day.year, day.month, day.day);
  final close = d.add(Duration(hours: barber.close));
  final out = <DateTime>[];
  for (var s = d.add(Duration(hours: barber.open));
      !s.add(Duration(minutes: minutes)).isAfter(close);
      s = s.add(const Duration(minutes: 30))) {
    if (s.isAfter(now) && isFree(existing, barber.id, s, minutes)) out.add(s);
  }
  return out;
}

/// First free slot within the next [days] days, or null.
DateTime? nextFreeSlot({
  required Barber barber,
  required int minutes,
  required Iterable<Appointment> existing,
  required DateTime now,
  int days = 7,
}) {
  for (var i = 0; i < days; i++) {
    final s = freeSlots(
        barber: barber,
        day: DateTime(now.year, now.month, now.day + i),
        minutes: minutes,
        existing: existing,
        now: now);
    if (s.isNotEmpty) return s.first;
  }
  return null;
}
