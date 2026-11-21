import 'package:flutter_test/flutter_test.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/auth/backend_auth_repository.dart';
import 'package:gobarber/models/user.dart';
import '../support/fake_auth_backend.dart';

Matcher failsWith(ErrorCode code) =>
    throwsA(isA<AppException>().having((e) => e.code, 'code', code));

void main() {
  late FakeAuthBackend backend;
  late BackendAuthRepository repo;

  setUp(() {
    backend = FakeAuthBackend();
    repo = BackendAuthRepository(backend);
  });

  group('register', () {
    test('creates a CUSTOMER, stores the name, sends the verification e-mail', () async {
      final u = await repo.register(name: 'Ali Ben', email: 'ali@example.com', password: 'Passw0rd1', languageCode: 'ar');
      expect(u.role, Role.customer);
      expect(u.name, 'Ali Ben');
      expect(u.emailVerified, isFalse);
      expect(u.isDemo, isFalse);
      expect(backend.verificationsSent, ['ali@example.com']);
      expect(backend.language, 'ar');
    });

    test('invalid input is rejected before reaching the backend', () async {
      await expectLater(repo.register(name: 'Ali', email: 'bad', password: 'Passw0rd1'), failsWith(ErrorCode.invalidEmail));
      await expectLater(repo.register(name: 'Ali', email: 'a@x.com', password: 'short1'), failsWith(ErrorCode.weakPassword));
      await expectLater(repo.register(name: 'Ali', email: 'a@x.com', password: 'onlyletters'), failsWith(ErrorCode.weakPassword));
      await expectLater(repo.register(name: 'A', email: 'a@x.com', password: 'Passw0rd1'), failsWith(ErrorCode.invalidInput));
      expect(backend.accountCount, 0);
    });

    test('duplicate e-mail and network failures map to clear errors', () async {
      await repo.register(name: 'Ali', email: 'ali@example.com', password: 'Passw0rd1');
      await expectLater(repo.register(name: 'Ali', email: 'ali@example.com', password: 'Passw0rd1'), failsWith(ErrorCode.emailInUse));
      backend.offline = true;
      await expectLater(repo.register(name: 'Bob', email: 'bob@example.com', password: 'Passw0rd1'), failsWith(ErrorCode.network));
    });
  });

  group('sign in / sign out', () {
    setUp(() => backend.seed(email: 'ali@example.com', password: 'Passw0rd1', name: 'Ali'));

    test('valid credentials sign in as a customer', () async {
      final u = await repo.signIn(' ali@example.com ', 'Passw0rd1');
      expect(u.email, 'ali@example.com');
      expect(u.role, Role.customer);
    });

    test('wrong password and unknown account give the SAME error', () async {
      await expectLater(repo.signIn('ali@example.com', 'wrong'), failsWith(ErrorCode.wrongCredentials));
      await expectLater(repo.signIn('nobody@example.com', 'Passw0rd1'), failsWith(ErrorCode.wrongCredentials));
      await expectLater(repo.signIn('ali@example.com', ''), failsWith(ErrorCode.wrongCredentials));
    });

    test('disabled accounts and network errors are reported', () async {
      backend.seed(email: 'off@example.com', password: 'Passw0rd1', disabled: true);
      await expectLater(repo.signIn('off@example.com', 'Passw0rd1'), failsWith(ErrorCode.userDisabled));
      backend.offline = true;
      await expectLater(repo.signIn('ali@example.com', 'Passw0rd1'), failsWith(ErrorCode.network));
    });

    test('sign out emits null', () async {
      await repo.signIn('ali@example.com', 'Passw0rd1');
      final events = <AppUser?>[];
      final sub = repo.authStateChanges().listen(events.add);
      await pumpEventQueue();
      await repo.signOut();
      await pumpEventQueue();
      await sub.cancel();
      expect(events.first?.email, 'ali@example.com');
      expect(events.last, isNull);
    });

    test('a restarted app restores the session from the backend', () async {
      await repo.signIn('ali@example.com', 'Passw0rd1');
      final restarted = BackendAuthRepository(backend); // new repository, same persisted session
      expect((await restarted.authStateChanges().first)?.email, 'ali@example.com');
    });
  });

  group('password reset', () {
    setUp(() => backend.seed(email: 'ali@example.com', password: 'Passw0rd1'));

    test('sends the reset e-mail in the requested language', () async {
      await repo.sendPasswordReset('ali@example.com', languageCode: 'fr');
      expect(backend.resetsSent, ['ali@example.com']);
      expect(backend.language, 'fr');
    });

    test('unknown accounts look exactly like known ones (no enumeration)', () async {
      await repo.sendPasswordReset('nobody@example.com');
      expect(backend.resetsSent, isEmpty);
    });

    test('malformed e-mail and network errors are reported', () async {
      await expectLater(repo.sendPasswordReset('bad'), failsWith(ErrorCode.invalidEmail));
      backend.offline = true;
      await expectLater(repo.sendPasswordReset('ali@example.com'), failsWith(ErrorCode.network));
    });
  });

  group('e-mail verification', () {
    test('reload picks up the verified flag', () async {
      backend.seed(email: 'ali@example.com', password: 'Passw0rd1');
      await repo.signIn('ali@example.com', 'Passw0rd1');
      expect((await repo.reloadUser())?.emailVerified, isFalse);
      backend.markVerifiedOnServer('ali@example.com');
      expect((await repo.reloadUser())?.emailVerified, isTrue);
    });
  });

  test('every Firebase error code maps to an error code', () {
    expect(BackendAuthRepository.mapCode('invalid-credential'), ErrorCode.wrongCredentials);
    expect(BackendAuthRepository.mapCode('too-many-requests'), ErrorCode.tooManyRequests);
    expect(BackendAuthRepository.mapCode('operation-not-allowed'), ErrorCode.unavailable);
    expect(BackendAuthRepository.mapCode('something-new'), ErrorCode.unknown);
  });
}
