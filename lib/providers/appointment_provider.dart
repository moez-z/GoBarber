import 'package:flutter/foundation.dart';
import 'package:gobarber/core/domain/availability.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/repositories.dart';
import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/models/barber.dart';
import 'package:gobarber/models/service.dart';
import 'package:gobarber/models/user.dart';

class AppointmentProvider extends ChangeNotifier {
  AppointmentProvider(this._repo);
  final AppointmentRepository _repo;

  List<Appointment> _items = const [];
  bool _loaded = false;
  ErrorCode? _error;

  List<Appointment> get all => _items;
  bool get loaded => _loaded;
  ErrorCode? get error => _error;

  Future<void> load() async {
    try {
      _items = await _repo.all();
      _error = null;
      _loaded = true;
    } on AppException catch (e) {
      _error = e.code;
    } catch (_) {
      _error = ErrorCode.unknown;
    }
    notifyListeners();
  }

  List<Appointment> forCustomer(String customerId) =>
      _items.where((a) => a.customerId == customerId).toList()..sort((a, b) => a.start.compareTo(b.start));

  List<Appointment> forBarberDay(String barberId, DateTime d) => _items
      .where((a) => a.barberId == barberId && a.status != Status.cancelled &&
          a.start.year == d.year && a.start.month == d.month && a.start.day == d.day)
      .toList()
    ..sort((a, b) => a.start.compareTo(b.start));

  List<DateTime> slots(Barber b, DateTime day, int minutes) =>
      freeSlots(barber: b, day: day, minutes: minutes, existing: _items, now: DateTime.now());

  DateTime? nextSlot(Barber b, int minutes) =>
      nextFreeSlot(barber: b, minutes: minutes, existing: _items, now: DateTime.now());

  /// Throws AppException(slotTaken) if the slot was taken meanwhile.
  Future<void> book({
    required AppUser customer,
    required Barber barber,
    required Service service,
    required DateTime start,
  }) async {
    await _repo.book(Appointment(
        id: '', customerId: customer.id, customerName: customer.name, barberId: barber.id,
        barberName: barber.name, serviceId: service.id, serviceName: service.name,
        start: start, minutes: service.minutes, priceMillimes: service.priceMillimes));
    await load();
  }

  Future<void> setStatus(Appointment a, Status s) async {
    await _repo.setStatus(a.id, s);
    await load();
  }
}
