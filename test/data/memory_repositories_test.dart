import 'package:flutter_test/flutter_test.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/memory/memory_repositories.dart';
import 'package:gobarber/models/appointment.dart';

void main() {
  late MemoryDb db;
  late MemoryCatalogRepository catalog;
  late MemoryAppointmentRepository appts;

  setUp(() {
    db = MemoryDb();
    catalog = MemoryCatalogRepository(db);
    appts = MemoryAppointmentRepository(db);
  });

  Future<void> expectCode(Future<void> Function() f, ErrorCode code) async {
    try {
      await f();
      fail('expected AppException($code)');
    } on AppException catch (e) {
      expect(e.code, code);
    }
  }

  Appointment draft(DateTime start, {String barberId = 'b1'}) => Appointment(
      id: '', customerId: 'u4', customerName: 'Alex', barberId: barberId, barberName: 'B',
      serviceId: 's1', serviceName: 'S', start: start, minutes: 40, priceMillimes: 35000);

  DateTime future() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day + 3, 10);
  }

  group('booking', () {
    test('a second booking of the same slot is rejected', () async {
      await appts.book(draft(future()));
      await expectCode(() => appts.book(draft(future())), ErrorCode.slotTaken);
      await appts.book(draft(future(), barberId: 'b2')); // other barber is free
    });
    test('cancelled slot can be booked again', () async {
      final a = await appts.book(draft(future()));
      await appts.setStatus(a.id, Status.cancelled);
      await appts.book(draft(future()));
    });
  });

  group('catalog', () {
    test('removing a barber keeps history and cancels upcoming appointments', () async {
      final a = await appts.book(draft(future()));
      final before = (await appts.all()).length;
      await catalog.removeBarber('b1');
      final all = await appts.all();
      expect(all.length, before);
      expect(all.firstWhere((x) => x.id == a.id).status, Status.cancelled);
      expect((await catalog.barbers()).any((b) => b.id == 'b1'), isFalse);
    });
    test('addService validates input', () async {
      await expectCode(() => catalog.addService(name: '', minutes: 30, priceMillimes: 1000), ErrorCode.invalidInput);
      await catalog.addService(name: 'Soin', minutes: 30, priceMillimes: 12500);
      expect((await catalog.services()).last.priceMillimes, 12500);
    });
  });
}
