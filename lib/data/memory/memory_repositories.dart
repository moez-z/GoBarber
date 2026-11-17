import 'package:gobarber/core/domain/availability.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/repositories.dart';
import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/models/barber.dart';
import 'package:gobarber/models/service.dart';
import 'package:gobarber/models/user.dart';

final _emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Demo data shared by the in-memory repositories. Not persisted.
class MemoryDb {
  MemoryDb() {
    users.addAll(const [
      AppUser(id: 'u0', name: 'CEO GoBarber', email: 'ceo@gobarber.com', role: Role.platformAdmin),
      AppUser(id: 'u1', name: 'Propriétaire', email: 'owner@gobarber.com', role: Role.owner),
      AppUser(id: 'u2', name: 'Marcus Vance', email: 'marcus@gobarber.com', role: Role.employee),
      AppUser(id: 'u3', name: 'Devon Taylor', email: 'devon@gobarber.com', role: Role.employee),
      AppUser(id: 'u4', name: 'Alex Wright', email: 'customer@gobarber.com', role: Role.customer),
    ]);
    barbers.addAll(const [
      Barber(id: 'b1', userId: 'u2', name: 'Marcus Vance', specialty: 'Fade', shop: 'Downtown Barber Co.', rating: 4.9, reviews: 184),
      Barber(id: 'b2', userId: 'u3', name: 'Devon Taylor', specialty: 'Barbier maître', shop: 'Atelier Blades', rating: 5.0, reviews: 312),
    ]);
    services.addAll(const [
      Service(id: 's1', name: 'Coupe & coiffage', minutes: 40, priceMillimes: 35000, desc: 'Consultation incluse'),
      Service(id: 's2', name: 'Barbe & taille', minutes: 25, priceMillimes: 20000, desc: 'Serviette chaude et finition au rasoir'),
      Service(id: 's3', name: 'Coupe + barbe', minutes: 60, priceMillimes: 50000, desc: 'Soin signature complet'),
      Service(id: 's4', name: 'Contours express', minutes: 15, priceMillimes: 18000, desc: 'Contours et nuque'),
    ]);
    final t = DateTime.now(), d = DateTime(t.year, t.month, t.day);
    _seed(barbers[0], services[0], d.add(const Duration(hours: 14, minutes: 30)));
    _seed(barbers[0], services[2], d.add(const Duration(hours: 16)));
    _seed(barbers[1], services[1], d.add(const Duration(hours: 11)));
  }

  int _id = 100;
  String nextId() => '${_id++}';
  final users = <AppUser>[];
  final barbers = <Barber>[];
  final services = <Service>[];
  final appointments = <Appointment>[];

  void _seed(Barber b, Service s, DateTime at) => appointments.add(Appointment(
      id: nextId(), customerId: 'u4', customerName: 'Alex Wright', barberId: b.id,
      barberName: b.name, serviceId: s.id, serviceName: s.name, start: at,
      minutes: s.minutes, priceMillimes: s.priceMillimes));
}

/// DEV ONLY. There are no passwords anywhere in the mock: [signIn] only checks that the
/// e-mail belongs to a demo account and [register] only validates the password's length
/// before discarding it. Real credential checks arrive with Firebase Auth in Phase 2.
class MemoryAuthRepository implements AuthRepository {
  MemoryAuthRepository(this._db);
  final MemoryDb _db;
  AppUser? _current;

  @override
  bool get supportsDemoSignIn => true;

  @override
  Future<AppUser?> restoreSession() async => _current;

  @override
  Future<AppUser> signIn(String email, String password) async {
    final e = email.trim().toLowerCase();
    final match = _db.users.where((u) => u.email == e);
    if (match.isEmpty || password.isEmpty) throw const AppException(ErrorCode.wrongCredentials);
    return _current = match.first;
  }

  @override
  Future<AppUser> signInDemo(Role role) async =>
      _current = _db.users.firstWhere((u) => u.role == role);

  @override
  Future<AppUser> register({required String name, required String email, required String password}) async {
    final e = email.trim().toLowerCase();
    if (name.trim().isEmpty || !_emailRe.hasMatch(e) || password.length < 6 ||
        _db.users.any((u) => u.email == e)) {
      throw const AppException(ErrorCode.invalidInput);
    }
    final user = AppUser(id: _db.nextId(), name: name.trim(), email: e, role: Role.customer);
    _db.users.add(user);
    return _current = user;
  }

  @override
  Future<void> signOut() async => _current = null;
}

class MemoryCatalogRepository implements CatalogRepository {
  MemoryCatalogRepository(this._db);
  final MemoryDb _db;

  @override
  Future<List<Barber>> barbers() async => List.of(_db.barbers);

  @override
  Future<List<Service>> services() async => List.of(_db.services);

  @override
  Future<Barber> addBarber({
    required String name,
    required String email,
    required String specialty,
    required String shop,
  }) async {
    final e = email.trim().toLowerCase();
    if (name.trim().isEmpty || !_emailRe.hasMatch(e) || _db.users.any((u) => u.email == e)) {
      throw const AppException(ErrorCode.invalidInput);
    }
    final user = AppUser(id: _db.nextId(), name: name.trim(), email: e, role: Role.employee);
    _db.users.add(user);
    final b = Barber(id: _db.nextId(), userId: user.id, name: user.name,
        specialty: specialty.trim(), shop: shop.trim());
    _db.barbers.add(b);
    return b;
  }

  /// Removing a barber keeps appointment history; upcoming active appointments are cancelled.
  @override
  Future<void> removeBarber(String id) async {
    final matches = _db.barbers.where((b) => b.id == id).toList();
    if (matches.isEmpty) return;
    _db.barbers.remove(matches.first);
    _db.users.removeWhere((u) => u.id == matches.first.userId);
    final now = DateTime.now();
    for (final a in _db.appointments) {
      if (a.barberId == id && a.end.isAfter(now) &&
          (a.status == Status.confirmed || a.status == Status.checkedIn)) {
        a.status = Status.cancelled;
      }
    }
  }

  @override
  Future<Service> addService({required String name, required int minutes, required int priceMillimes}) async {
    if (name.trim().isEmpty || minutes <= 0 || priceMillimes < 0) {
      throw const AppException(ErrorCode.invalidInput);
    }
    final s = Service(id: _db.nextId(), name: name.trim(), minutes: minutes, priceMillimes: priceMillimes);
    _db.services.add(s);
    return s;
  }

  @override
  Future<void> removeService(String id) async => _db.services.removeWhere((s) => s.id == id);
}

class MemoryAppointmentRepository implements AppointmentRepository {
  MemoryAppointmentRepository(this._db);
  final MemoryDb _db;

  @override
  Future<List<Appointment>> all() async => List.of(_db.appointments);

  @override
  Future<Appointment> book(Appointment draft) async {
    if (!isFree(_db.appointments, draft.barberId, draft.start, draft.minutes)) {
      throw const AppException(ErrorCode.slotTaken);
    }
    final a = draft.copyWithId(_db.nextId());
    _db.appointments.add(a);
    return a;
  }

  @override
  Future<void> setStatus(String id, Status status) async {
    for (final a in _db.appointments) {
      if (a.id == id) a.status = status;
    }
  }
}
