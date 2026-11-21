enum Role { customer, employee, owner, platformAdmin }

/// A signed-in person. Deliberately has NO password field: credentials are handled
/// only by Firebase Auth.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.emailVerified = true,
    this.isDemo = false,
  });
  final String id, name, email;
  final Role role;
  final bool emailVerified;

  /// True only for debug-build demo identities. They have no Firebase identity, so they can
  /// never read or write real Firestore data.
  final bool isDemo;
}
