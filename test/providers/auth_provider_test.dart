import 'package:flutter_test/flutter_test.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/auth/backend_auth_repository.dart';
import 'package:gobarber/models/user.dart';
import 'package:gobarber/providers/auth_provider.dart';
import '../support/fake_auth_backend.dart';

void main() {
  late FakeAuthBackend backend;
  late BackendAuthRepository repo;

  setUp(() {
    backend = FakeAuthBackend();
    repo = BackendAuthRepository(backend);
    backend.seed(email: 'ali@example.com', password: 'Passw0rd1', name: 'Ali');
  });

  test('initializing ends after the first auth event; no user when signed out', () async {
    final p = AuthProvider(repo, demoEnabled: false);
    expect(p.initializing, isTrue);
    await pumpEventQueue();
    expect(p.initializing, isFalse);
    expect(p.user, isNull);
    p.dispose();
  });

  test('an existing session is restored at startup', () async {
    await repo.signIn('ali@example.com', 'Passw0rd1');
    final p = AuthProvider(repo, demoEnabled: false);
    await pumpEventQueue();
    expect(p.user?.email, 'ali@example.com');
    p.dispose();
  });

  test('sign in / sign out and error reporting', () async {
    final p = AuthProvider(repo, demoEnabled: false);
    await pumpEventQueue();
    expect(await p.signIn('ali@example.com', 'bad'), isFalse);
    expect(p.error, ErrorCode.wrongCredentials);
    expect(p.user, isNull);
    expect(await p.signIn('ali@example.com', 'Passw0rd1'), isTrue);
    expect(p.error, isNull);
    expect(p.user?.role, Role.customer);
    await p.signOut();
    expect(p.user, isNull);
    p.dispose();
  });

  test('registration signs in a customer, never a higher role', () async {
    final p = AuthProvider(repo, demoEnabled: false);
    await pumpEventQueue();
    expect(await p.register('Sami', 'sami@example.com', 'Passw0rd1', languageCode: 'fr'), isTrue);
    expect(p.user?.role, Role.customer);
    expect(p.user?.emailVerified, isFalse);
    p.dispose();
  });

  test('password reset reports success and errors', () async {
    final p = AuthProvider(repo, demoEnabled: false);
    expect(await p.sendPasswordReset('ali@example.com'), isTrue);
    expect(await p.sendPasswordReset('nope'), isFalse);
    expect(p.error, ErrorCode.invalidEmail);
    p.dispose();
  });

  test('refreshUser reports when the e-mail becomes verified', () async {
    final p = AuthProvider(repo, demoEnabled: false);
    await p.signIn('ali@example.com', 'Passw0rd1');
    expect(await p.refreshUser(), isFalse);
    backend.markVerifiedOnServer('ali@example.com');
    expect(await p.refreshUser(), isTrue);
    expect(p.user?.emailVerified, isTrue);
    p.dispose();
  });

  group('demo mode', () {
    test('is refused when disabled (release builds)', () async {
      final p = AuthProvider(repo, demoEnabled: false);
      expect(p.signInDemo(Role.owner), isFalse);
      expect(p.user, isNull);
      expect(p.error, ErrorCode.unavailable);
      p.dispose();
    });

    test('works when enabled but never touches the authentication backend', () async {
      final p = AuthProvider(repo, demoEnabled: true);
      expect(p.signInDemo(Role.owner), isTrue);
      expect(p.user?.role, Role.owner);
      expect(p.user?.isDemo, isTrue);
      expect(p.isDemoSession, isTrue);
      expect(backend.signInCalls, 0);
      await p.signOut();
      expect(p.user, isNull);
      expect(backend.signOutCalls, 0);
      p.dispose();
    });
  });
}
