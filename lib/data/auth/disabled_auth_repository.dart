import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/repositories.dart';
import 'package:gobarber/models/user.dart';

/// Used on platforms where Firebase is not configured (iOS, macOS, Windows, Linux).
/// Real sign-in is unavailable there; only debug demo accounts work.
class DisabledAuthRepository implements AuthRepository {
  const DisabledAuthRepository();
  static const _off = AppException(ErrorCode.unavailable);

  @override
  Stream<AppUser?> authStateChanges() => Stream<AppUser?>.value(null);
  @override
  Future<AppUser> signIn(String email, String password) async => throw _off;
  @override
  Future<AppUser> register({required String name, required String email, required String password, String? languageCode}) async => throw _off;
  @override
  Future<void> sendPasswordReset(String email, {String? languageCode}) async => throw _off;
  @override
  Future<void> sendEmailVerification({String? languageCode}) async => throw _off;
  @override
  Future<AppUser?> reloadUser() async => null;
  @override
  Future<void> signOut() async {}
}
