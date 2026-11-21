import 'dart:async';
import 'package:gobarber/data/auth/auth_backend.dart';

class _Rec {
  _Rec(this.password, this.account);
  final String password;
  AuthAccount account;
  bool disabled = false;
}

/// In-memory stand-in for Firebase Auth. Passwords exist only inside this test double.
class FakeAuthBackend implements AuthBackend {
  final _records = <String, _Rec>{};
  final _ctl = StreamController<AuthAccount?>.broadcast();
  AuthAccount? _current;

  int signInCalls = 0, signOutCalls = 0;
  final verificationsSent = <String>[];
  final resetsSent = <String>[];
  String? language;
  bool offline = false;

  int get accountCount => _records.length;

  void seed({required String email, required String password, String? name, bool verified = false, bool disabled = false}) {
    _records[email] = _Rec(
        password,
        AuthAccount(uid: 'uid-${_records.length + 1}', email: email, displayName: name, emailVerified: verified))
      ..disabled = disabled;
  }

  /// Simulates the user clicking the link in the verification e-mail (server side only).
  void markVerifiedOnServer(String email) {
    final r = _records[email]!;
    r.account = AuthAccount(uid: r.account.uid, email: email, displayName: r.account.displayName, emailVerified: true);
  }

  void _check() {
    if (offline) throw const BackendAuthException('network-request-failed');
  }

  void _emit(AuthAccount? a) {
    _current = a;
    _ctl.add(a);
  }

  @override
  Stream<AuthAccount?> userChanges() async* {
    yield _current;
    yield* _ctl.stream;
  }

  @override
  Future<void> setLanguage(String? code) async => language = code;

  @override
  Future<AuthAccount> signIn(String email, String password) async {
    _check();
    signInCalls++;
    final r = _records[email];
    if (r == null) throw const BackendAuthException('user-not-found');
    if (r.disabled) throw const BackendAuthException('user-disabled');
    if (r.password != password) throw const BackendAuthException('wrong-password');
    _emit(r.account);
    return r.account;
  }

  @override
  Future<AuthAccount> createUser(String email, String password) async {
    _check();
    if (_records.containsKey(email)) throw const BackendAuthException('email-already-in-use');
    if (password.length < 6) throw const BackendAuthException('weak-password');
    seed(email: email, password: password);
    final acc = _records[email]!.account;
    _emit(acc);
    return acc;
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final c = _current!;
    final updated = AuthAccount(uid: c.uid, email: c.email, displayName: name, emailVerified: c.emailVerified);
    _records[c.email]!.account = updated;
    _emit(updated);
  }

  @override
  Future<void> sendEmailVerification() async {
    _check();
    verificationsSent.add(_current!.email);
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    _check();
    if (!_records.containsKey(email)) throw const BackendAuthException('user-not-found');
    resetsSent.add(email);
  }

  @override
  Future<AuthAccount?> reload() async {
    final c = _current;
    if (c == null) return null;
    final fresh = _records[c.email]!.account;
    _emit(fresh);
    return fresh;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _emit(null);
  }
}
