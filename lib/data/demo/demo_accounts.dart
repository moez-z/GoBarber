import 'package:gobarber/models/user.dart';

/// Debug-only demo identities (no passwords, no Firebase identity). They only see the
/// in-memory demo data and are unreachable in release builds (see AppConfig.demoEnabled).
/// The ids match the barber/appointment ids seeded by MemoryDb.
const demoUsers = <AppUser>[
  AppUser(id: 'u0', name: 'CEO GoBarber', email: 'ceo@demo.local', role: Role.platformAdmin, isDemo: true),
  AppUser(id: 'u1', name: 'Propriétaire', email: 'owner@demo.local', role: Role.owner, isDemo: true),
  AppUser(id: 'u2', name: 'Marcus Vance', email: 'marcus@demo.local', role: Role.employee, isDemo: true),
  AppUser(id: 'u3', name: 'Devon Taylor', email: 'devon@demo.local', role: Role.employee, isDemo: true),
  AppUser(id: 'u4', name: 'Alex Wright', email: 'customer@demo.local', role: Role.customer, isDemo: true),
];

AppUser demoUserFor(Role role) => demoUsers.firstWhere((u) => u.role == role);
