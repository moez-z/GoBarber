import 'package:flutter_test/flutter_test.dart';
import 'package:gobarber/core/domain/availability.dart';
import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/models/barber.dart';

Appointment appt(DateTime start, int minutes, {Status status = Status.confirmed, String barberId = 'b1'}) =>
    Appointment(
        id: 'x', customerId: 'c', customerName: 'C', barberId: barberId, barberName: 'B',
        serviceId: 's', serviceName: 'S', start: start, minutes: minutes, priceMillimes: 1000,
        status: status);

void main() {
  const barber = Barber(id: 'b1', userId: 'u', name: 'B', specialty: '', shop: '');
  final day = DateTime(2030, 1, 1);
  final morning = DateTime(2030, 1, 1, 8);

  test('slots stay inside opening hours', () {
    final s = freeSlots(barber: barber, day: day, minutes: 60, existing: [], now: morning);
    expect(s.first, DateTime(2030, 1, 1, 9));
    expect(s.last, DateTime(2030, 1, 1, 18));
    expect(s.contains(DateTime(2030, 1, 1, 18, 30)), isFalse);
  });

  test('overlapping appointments block slots (no double booking)', () {
    final s = freeSlots(
        barber: barber, day: day, minutes: 30,
        existing: [appt(DateTime(2030, 1, 1, 10), 40)], now: morning);
    expect(s.contains(DateTime(2030, 1, 1, 9, 30)), isTrue);
    expect(s.contains(DateTime(2030, 1, 1, 10)), isFalse);
    expect(s.contains(DateTime(2030, 1, 1, 10, 30)), isFalse);
    expect(s.contains(DateTime(2030, 1, 1, 11)), isTrue);
  });

  test('cancelled appointments and other barbers do not block', () {
    final s = freeSlots(
        barber: barber, day: day, minutes: 30,
        existing: [
          appt(DateTime(2030, 1, 1, 10), 40, status: Status.cancelled),
          appt(DateTime(2030, 1, 1, 12), 40, barberId: 'other'),
        ],
        now: morning);
    expect(s.contains(DateTime(2030, 1, 1, 10)), isTrue);
    expect(s.contains(DateTime(2030, 1, 1, 12)), isTrue);
  });

  test('past slots are excluded', () {
    final s = freeSlots(barber: barber, day: day, minutes: 30, existing: [], now: DateTime(2030, 1, 1, 12));
    expect(s.first, DateTime(2030, 1, 1, 12, 30));
  });

  test('nextFreeSlot moves to the next day when today is full', () {
    final full = appt(DateTime(2030, 1, 1, 9), 600); // 09:00-19:00
    final next = nextFreeSlot(barber: barber, minutes: 30, existing: [full], now: morning);
    expect(next, DateTime(2030, 1, 2, 9));
  });
}
