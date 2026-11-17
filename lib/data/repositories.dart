import 'package:gobarber/models/appointment.dart';
import 'package:gobarber/models/barber.dart';
import 'package:gobarber/models/service.dart';
import 'package:gobarber/models/user.dart';

/// Repository interfaces: the UI and Providers depend only on these, so the in-memory
/// demo implementation can be replaced by Firebase (Phase 2/3) without touching screens.
/// Implementations throw `AppException` on expected failures.
abstract class AuthRepository {
  /// True only for the in-memory demo implementation (one-tap demo sign-in).
  bool get supportsDemoSignIn;
  Future<AppUser?> restoreSession();
  Future<AppUser> signIn(String email, String password);
  Future<AppUser> signInDemo(Role role);
  Future<AppUser> register({required String name, required String email, required String password});
  Future<void> signOut();
}

abstract class CatalogRepository {
  Future<List<Barber>> barbers();
  Future<List<Service>> services();
  Future<Barber> addBarber({
    required String name,
    required String email,
    required String specialty,
    required String shop,
  });
  Future<void> removeBarber(String id);
  Future<Service> addService({required String name, required int minutes, required int priceMillimes});
  Future<void> removeService(String id);
}

abstract class AppointmentRepository {
  Future<List<Appointment>> all();

  /// Throws AppException(ErrorCode.slotTaken) when the slot overlaps another appointment.
  Future<Appointment> book(Appointment draft);
  Future<void> setStatus(String id, Status status);
}
