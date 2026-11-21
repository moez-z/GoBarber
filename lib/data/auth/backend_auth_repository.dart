import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/core/validation/validators.dart';
import 'package:gobarber/data/auth/auth_backend.dart';
import 'package:gobarber/data/repositories.dart';
import 'package:gobarber/models/user.dart';

/// Real authentication on top of an [AuthBackend] (Firebase in the app, a fake in tests).
class BackendAuthRepository implements AuthRepository {
  BackendAuthRepository(this._backend);
  final AuthBackend _backend;

  AppUser _toUser(AuthAccount a) {
    final dn = a.displayName?.trim();
    final name = (dn != null && dn.isNotEmpty)
        ? dn
        : (a.email.contains('@') ? a.email.split('@').first : a.email);
    // Phase 2.2: every real account is a customer. Phase 2.3 reads the role from users/{uid}
    // (enforced by security rules); nothing in the app can self-assign a higher role.
    return AppUser(id: a.uid, name: name, email: a.email, role: Role.customer, emailVerified: a.emailVerified);
  }

  static ErrorCode mapCode(String code) => switch (code) {
        'invalid-email' => ErrorCode.invalidEmail,
        'user-disabled' => ErrorCode.userDisabled,
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' ||
        'invalid-login-credentials' =>
          ErrorCode.wrongCredentials,
        'email-already-in-use' => ErrorCode.emailInUse,
        'weak-password' => ErrorCode.weakPassword,
        'too-many-requests' => ErrorCode.tooManyRequests,
        'network-request-failed' => ErrorCode.network,
        'operation-not-allowed' => ErrorCode.unavailable,
        _ => ErrorCode.unknown,
      };

  Future<T> _run<T>(Future<T> Function() f) async {
    try {
      return await f();
    } on BackendAuthException catch (e) {
      throw AppException(mapCode(e.code));
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException(ErrorCode.unknown);
    }
  }

  Future<void> _language(String? code) async {
    try {
      await _backend.setLanguage(code);
    } catch (_) {/* the e-mail just stays in the default language */}
  }

  @override
  Stream<AppUser?> authStateChanges() => _backend.userChanges().map((a) => a == null ? null : _toUser(a));

  @override
  Future<AppUser> signIn(String email, String password) async {
    // Same message for every credential failure: do not reveal which accounts exist.
    if (validateEmail(email) != null || password.isEmpty) {
      throw const AppException(ErrorCode.wrongCredentials);
    }
    return _toUser(await _run(() => _backend.signIn(email.trim(), password)));
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    String? languageCode,
  }) async {
    if (validateEmail(email) != null) throw const AppException(ErrorCode.invalidEmail);
    if (validatePassword(password) != null) throw const AppException(ErrorCode.weakPassword);
    if (validateName(name) != null) throw const AppException(ErrorCode.invalidInput);

    await _language(languageCode);
    var account = await _run(() => _backend.createUser(email.trim(), password));
    // Best effort: the account exists even if these two steps fail (the banner offers a resend).
    try {
      await _backend.updateDisplayName(name.trim());
    } catch (_) {}
    try {
      await _backend.sendEmailVerification();
    } catch (_) {}
    try {
      account = await _backend.reload() ?? account;
    } catch (_) {}
    return _toUser(account);
  }

  @override
  Future<void> sendPasswordReset(String email, {String? languageCode}) async {
    if (validateEmail(email) != null) throw const AppException(ErrorCode.invalidEmail);
    await _language(languageCode);
    try {
      await _backend.sendPasswordReset(email.trim());
    } on BackendAuthException catch (e) {
      if (e.code == 'user-not-found') return; // neutral: never reveal whether the account exists
      throw AppException(mapCode(e.code));
    } catch (_) {
      throw const AppException(ErrorCode.unknown);
    }
  }

  @override
  Future<void> sendEmailVerification({String? languageCode}) async {
    await _language(languageCode);
    await _run(() => _backend.sendEmailVerification());
  }

  @override
  Future<AppUser?> reloadUser() async {
    final a = await _run(() => _backend.reload());
    return a == null ? null : _toUser(a);
  }

  @override
  Future<void> signOut() => _run(() => _backend.signOut());
}
