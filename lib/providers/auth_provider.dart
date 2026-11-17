import 'package:flutter/foundation.dart';
import 'package:gobarber/core/errors/app_exception.dart';
import 'package:gobarber/data/repositories.dart';
import 'package:gobarber/models/user.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repo);
  final AuthRepository _repo;

  AppUser? _user;
  bool _busy = false;
  ErrorCode? _error;

  AppUser? get user => _user;
  bool get busy => _busy;
  ErrorCode? get error => _error;
  bool get supportsDemo => _repo.supportsDemoSignIn;

  Future<bool> signIn(String email, String password) => _run(() => _repo.signIn(email, password));
  Future<bool> signInDemo(Role role) => _run(() => _repo.signInDemo(role));
  Future<bool> register(String name, String email, String password) =>
      _run(() => _repo.register(name: name, email: email, password: password));

  Future<bool> _run(Future<AppUser> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      _user = await action();
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

  Future<void> signOut() async {
    await _repo.signOut();
    _user = null;
    _error = null;
    notifyListeners();
  }
}
