/// Minimal view of an authentication account, independent of any SDK.
class AuthAccount {
  const AuthAccount({
    required this.uid,
    required this.email,
    this.displayName,
    required this.emailVerified,
  });
  final String uid, email;
  final String? displayName;
  final bool emailVerified;
}

/// Error carrying the provider's error code (e.g. Firebase's 'wrong-password').
class BackendAuthException implements Exception {
  const BackendAuthException(this.code);
  final String code;
  @override
  String toString() => 'BackendAuthException($code)';
}

/// Thin seam over the auth SDK so the repository logic can be tested without Firebase.
abstract class AuthBackend {
  Stream<AuthAccount?> userChanges();
  Future<void> setLanguage(String? code);
  Future<AuthAccount> signIn(String email, String password);
  Future<AuthAccount> createUser(String email, String password);
  Future<void> updateDisplayName(String name);
  Future<void> sendEmailVerification();
  Future<void> sendPasswordReset(String email);
  Future<AuthAccount?> reload();
  Future<void> signOut();
}
