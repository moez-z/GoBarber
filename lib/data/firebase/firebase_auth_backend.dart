import 'package:firebase_auth/firebase_auth.dart';
import 'package:gobarber/data/auth/auth_backend.dart';

/// The only file that talks to the Firebase Auth SDK.
/// Sessions persist across launches (Android: secure storage, web: IndexedDB).
class FirebaseAuthBackend implements AuthBackend {
  FirebaseAuthBackend([FirebaseAuth? auth]) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;

  AuthAccount? _map(User? u) => u == null
      ? null
      : AuthAccount(
          uid: u.uid,
          email: u.email ?? '',
          displayName: u.displayName,
          emailVerified: u.emailVerified);

  Future<T> _guard<T>(Future<T> Function() f) async {
    try {
      return await f();
    } on FirebaseAuthException catch (e) {
      throw BackendAuthException(e.code);
    }
  }

  @override
  Stream<AuthAccount?> userChanges() => _auth.userChanges().map(_map);

  @override
  Future<void> setLanguage(String? code) => _auth.setLanguageCode(code);

  @override
  Future<AuthAccount> signIn(String email, String password) => _guard(() async {
        final c = await _auth.signInWithEmailAndPassword(email: email, password: password);
        return _map(c.user)!;
      });

  @override
  Future<AuthAccount> createUser(String email, String password) => _guard(() async {
        final c = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        return _map(c.user)!;
      });

  @override
  Future<void> updateDisplayName(String name) => _guard(() async {
        await _auth.currentUser?.updateDisplayName(name);
      });

  @override
  Future<void> sendEmailVerification() => _guard(() async {
        await _auth.currentUser?.sendEmailVerification();
      });

  @override
  Future<void> sendPasswordReset(String email) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email));

  @override
  Future<AuthAccount?> reload() => _guard(() async {
        await _auth.currentUser?.reload();
        return _map(_auth.currentUser);
      });

  @override
  Future<void> signOut() => _guard(() => _auth.signOut());
}
