import 'package:flutter_test/flutter_test.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/memory/memory_repositories.dart';
import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/models/user.dart';

void main() {
  late MemoryDb db;
  late MemoryAuthRepository auth;
  late MemoryCatalogRepository catalog;
  late MemoryAppointmentRepository appts;

  setUp(() {
    db = MemoryDb();
    auth = MemoryAuthRepository(db);
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

  group('auth (mock, no passwords stored)', () {
    test('unknown e-mail or empty password is rejected', () async {
      await expectCode(() => auth.signIn('nobody@x.com', 'abc'), ErrorCode.wrongCredentials);
      await expectCode(() => auth.signIn('owner@gobarber.com', ''), ErrorCode.wrongCredentials);
    });
    test('the four roles exist and demo sign-in returns each role', () async {
      for (final r in Role.values) {
        expect((await auth.signInDemo(r)).role, r);
      }
    });
    test('register validates input and creates a customer', () async {
      await expectCode(() => auth.register(name: 'A', email: 'bad', password: '123456'), ErrorCode.invalidInput);
      await expectCode(() => auth.register(name: 'A', email: 'a@x.com', password: '123'), ErrorCode.invalidInput);
      final u = await auth.register(name: 'Ali', email: 'ali@x.com', password: '123456');
      expect(u.role, Role.customer);
      await expectCode(() => auth.register(name: 'Ali', email: 'ali@x.com', password: '123456'), ErrorCode.invalidInput);
    });
  });

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
