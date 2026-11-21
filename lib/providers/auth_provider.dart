import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gobarber/core/config/app_config.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/demo/demo_accounts.dart';
import 'package:gobarber/data/repositories.dart';
import 'package:gobarber/models/user.dart';

/// Holds the signed-in user. Two clearly separated sources:
///  * the real user, restored from / pushed by the AuthRepository (Firebase);
///  * a debug-only demo user that never touches the repository or Firebase.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repo, {bool? demoEnabled}) : demoEnabled = demoEnabled ?? AppConfig.demoEnabled {
    _sub = _repo.authStateChanges().listen(_onRemote, onError: (Object _) => _onRemote(null));
  }

  final AuthRepository _repo;
  final bool demoEnabled;
  StreamSubscription<AppUser?>? _sub;

  AppUser? _remoteUser;
  AppUser? _demoUser;
  bool _initializing = true;
  bool _busy = false;
  ErrorCode? _error;

  AppUser? get user => _demoUser ?? _remoteUser;
  bool get isDemoSession => _demoUser != null;

  /// True until the first auth state (session restore) arrives; the app shows a loader.
  bool get initializing => _initializing;
  bool get busy => _busy;
  ErrorCode? get error => _error;

  void _onRemote(AppUser? u) {
    _remoteUser = u;
    _initializing = false;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AppException catch (e) {
      _error = e.code;
      return false;
    } catch (_) {
      _error = ErrorCode.unknown;
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) => _run(() async {
        _remoteUser = await _repo.signIn(email, password);
        _demoUser = null;
      });

  Future<bool> register(String name, String email, String password, {String? languageCode}) =>
      _run(() async {
        _remoteUser = await _repo.register(
            name: name, email: email, password: password, languageCode: languageCode);
        _demoUser = null;
      });

  Future<bool> sendPasswordReset(String email, {String? languageCode}) =>
      _run(() => _repo.sendPasswordReset(email, languageCode: languageCode));

  Future<bool> resendVerification({String? languageCode}) =>
      _run(() => _repo.sendEmailVerification(languageCode: languageCode));

  /// Re-reads the account from the server. Returns true when the e-mail is now verified.
  Future<bool> refreshUser() async {
    try {
      final u = await _repo.reloadUser();
      if (u != null) {
        _remoteUser = u;
        notifyListeners();
      }
      return u?.emailVerified ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Debug builds only. Never calls the repository, so it cannot create a Firebase session.
  bool signInDemo(Role role) {
    if (!demoEnabled) {
      _error = ErrorCode.unavailable;
      notifyListeners();
      return false;
    }
    _demoUser = demoUserFor(role);
    _error = null;
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    if (_demoUser != null) {
      _demoUser = null;
    } else {
      try {
        await _repo.signOut();
      } catch (_) {}
      _remoteUser = null;
    }
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
