import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/repositories.dart';
import 'package:gobarber/models/barber.dart';
import 'package:gobarber/models/service.dart';

/// Barbers and services. Mutating methods let `AppException` propagate so the UI can show it.
class CatalogProvider extends ChangeNotifier {
  CatalogProvider(this._repo);
  final CatalogRepository _repo;

  List<Barber> _barbers = const [];
  List<Service> _services = const [];
  bool _loaded = false;
  ErrorCode? _error;

  List<Barber> get barbers => _barbers;
  List<Service> get services => _services;
  bool get loaded => _loaded;
  ErrorCode? get error => _error;

  int? get shortestServiceMinutes =>
      _services.isEmpty ? null : _services.map((s) => s.minutes).reduce(math.min);
  int? get cheapestPriceMillimes =>
      _services.isEmpty ? null : _services.map((s) => s.priceMillimes).reduce(math.min);

  Barber? barberById(String id) => _barbers.where((b) => b.id == id).firstOrNull;
  Barber? barberForUser(String userId) => _barbers.where((b) => b.userId == userId).firstOrNull;

  Future<void> load() async {
    try {
      _barbers = await _repo.barbers();
      _services = await _repo.services();
      _error = null;
      _loaded = true;
    } on AppException catch (e) {
      _error = e.code;
    } catch (_) {
      _error = ErrorCode.unknown;
    }
    notifyListeners();
  }

  Future<void> addBarber({required String name, required String email, required String specialty, required String shop}) async {
    await _repo.addBarber(name: name, email: email, specialty: specialty, shop: shop);
    await load();
  }

  Future<void> removeBarber(Barber b) async {
    await _repo.removeBarber(b.id);
    await load();
  }

  Future<void> addService({required String name, required int minutes, required int priceMillimes}) async {
    await _repo.addService(name: name, minutes: minutes, priceMillimes: priceMillimes);
    await load();
  }

  Future<void> removeService(Service s) async {
    await _repo.removeService(s.id);
    await load();
  }
}
