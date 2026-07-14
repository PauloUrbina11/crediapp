import 'package:flutter/foundation.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login({required String email, required String password}) {
    return _run(() async {
      _currentUser = await _repository.login(email: email, password: password);
    });
  }

  Future<bool> register({
    required String fullName,
    required String documentId,
    required String email,
    required String password,
  }) {
    return _run(() async {
      _currentUser = await _repository.register(
        fullName: fullName,
        documentId: documentId,
        email: email,
        password: password,
      );
    });
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
