enum Role { customer, employee, owner, platformAdmin }

/// A signed-in person. Deliberately has NO password field: credentials are handled
/// only by the authentication backend (Firebase Auth from Phase 2).
class AppUser {
  const AppUser({required this.id, required this.name, required this.email, required this.role});
  final String id, name, email;
  final Role role;
}
