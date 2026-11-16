import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'models.dart';

/// In-memory app state. Swap the bodies of these methods for Firebase/Supabase/REST
/// calls to persist data; the UI only talks to this class.
class Store extends ChangeNotifier {
  int _id = 100;
  String _nid() => '${_id++}';
  final users = <AppUser>[];
  final barbers = <Barber>[];
  final services = <Service>[];
  final appts = <Appointment>[];
  AppUser? me;

  Store() {
    users.addAll([
      AppUser('u1', 'Admin', 'admin@gobarber.com', 'admin123', Role.admin),
      AppUser('u2', 'Marcus Vance', 'marcus@gobarber.com', 'barber123', Role.barber),
      AppUser('u3', 'Devon Taylor', 'devon@gobarber.com', 'barber123', Role.barber),
      AppUser('u4', 'Alex Wright', 'customer@gobarber.com', 'customer123', Role.customer),
    ]);
    barbers.addAll([
      Barber('b1', 'u2', 'Marcus Vance', 'Fade Specialist', 'Downtown Barber Co.', 4.9, 184),
      Barber('b2', 'u3', 'Devon Taylor', 'Master Barber', 'Atelier Blades', 5.0, 312),
    ]);
    services.addAll([
      Service('s1', 'Haircut & Style', 40, 35, 'Consultation included'),
      Service('s2', 'Beard Grooming & Trim', 25, 20, 'Hot towel & razor finish'),
      Service('s3', 'Haircut + Beard Combo', 60, 50, 'Full signature treatment'),
      Service('s4', 'Express Lineup', 15, 18, 'Edge touch-up & neck clean'),
    ]);
    final t = DateTime.now(), d = DateTime(t.year, t.month, t.day);
    _seed('b1', services[0], d.add(const Duration(hours: 14, minutes: 30)));
    _seed('b1', services[2], d.add(const Duration(hours: 16)));
    _seed('b2', services[1], d.add(const Duration(hours: 11)));
  }

  void _seed(String bid, Service s, DateTime at) {
    final b = barber(bid);
    appts.add(Appointment(
        id: _nid(), customerId: 'u4', customerName: 'Alex Wright', barberId: b.id,
        barberName: b.name, serviceId: s.id, serviceName: s.name, start: at,
        minutes: s.minutes, price: s.price));
  }

  // ---- auth ----
  bool login(String email, String pw) {
    final m = users.where((u) => u.email == email.trim().toLowerCase() && u.password == pw);
    if (m.isEmpty) return false;
    me = m.first;
    notifyListeners();
    return true;
  }

  bool register(String name, String email, String pw) {
    final e = email.trim().toLowerCase();
    if (name.trim().isEmpty || !e.contains('@') || pw.length < 6 || users.any((u) => u.email == e)) {
      return false;
    }
    me = AppUser(_nid(), name.trim(), e, pw, Role.customer);
    users.add(me!);
    notifyListeners();
    return true;
  }

  void logout() {
    me = null;
    notifyListeners();
  }

  // ---- lookups ----
  Barber barber(String id) => barbers.firstWhere((b) => b.id == id);
  Barber get myBarber => barbers.firstWhere((b) => b.userId == me!.id);

  List<Appointment> mine() =>
      appts.where((a) => a.customerId == me!.id).toList()..sort((a, b) => a.start.compareTo(b.start));

  List<Appointment> dayAppts(String bid, DateTime d) => appts
      .where((a) => a.barberId == bid && a.status != Status.cancelled &&
          a.start.year == d.year && a.start.month == d.month && a.start.day == d.day)
      .toList()
    ..sort((a, b) => a.start.compareTo(b.start));

  // ---- availability ----
  bool busy(String bid, DateTime s, int minutes) {
    final e = s.add(Duration(minutes: minutes));
    return appts.any((a) => a.barberId == bid && a.status != Status.cancelled &&
        s.isBefore(a.end) && e.isAfter(a.start));
  }

  /// Free start times (30-min grid) for a barber on a day, for a service length.
  List<DateTime> slots(String bid, DateTime day, int minutes) {
    final b = barber(bid), d = DateTime(day.year, day.month, day.day);
    final close = d.add(Duration(hours: b.close)), now = DateTime.now();
    final out = <DateTime>[];
    for (var s = d.add(Duration(hours: b.open));
        !s.add(Duration(minutes: minutes)).isAfter(close);
        s = s.add(const Duration(minutes: 30))) {
      if (s.isAfter(now) && !busy(bid, s, minutes)) out.add(s);
    }
    return out;
  }

  DateTime? nextSlot(String bid) {
    if (services.isEmpty) return null;
    final m = services.map((s) => s.minutes).reduce(math.min), n = DateTime.now();
    for (var i = 0; i < 7; i++) {
      final s = slots(bid, DateTime(n.year, n.month, n.day + i), m);
      if (s.isNotEmpty) return s.first;
    }
    return null;
  }

  // ---- booking ----
  bool book(String bid, Service s, DateTime start) {
    if (busy(bid, start, s.minutes)) return false;
    final b = barber(bid);
    appts.add(Appointment(
        id: _nid(), customerId: me!.id, customerName: me!.name, barberId: b.id,
        barberName: b.name, serviceId: s.id, serviceName: s.name, start: start,
        minutes: s.minutes, price: s.price));
    notifyListeners();
    return true;
  }

  void setStatus(Appointment a, Status s) {
    a.status = s;
    notifyListeners();
  }

  // ---- admin ----
  void addBarber(String name, String email, String pw, String spec, String shop) {
    final uid = _nid();
    users.add(AppUser(uid, name, email.trim().toLowerCase(), pw, Role.barber));
    barbers.add(Barber(_nid(), uid, name, spec, shop));
    notifyListeners();
  }

  void removeBarber(Barber b) {
    barbers.remove(b);
    users.removeWhere((u) => u.id == b.userId);
    appts.removeWhere((a) => a.barberId == b.id);
    notifyListeners();
  }

  void addService(String name, int min, double price) {
    services.add(Service(_nid(), name, min, price, ''));
    notifyListeners();
  }

  void removeService(Service s) {
    services.remove(s);
    notifyListeners();
  }
}
