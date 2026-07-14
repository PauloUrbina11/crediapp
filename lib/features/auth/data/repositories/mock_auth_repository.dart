import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// In-memory auth backend used while the app has no real authentication
/// provider wired up. Swap for a Firebase-backed [AuthRepository]
/// implementation without touching any presentation code.
class MockAuthRepository implements AuthRepository {
  final Map<String, AppUser> _usersByEmail = {};
  int _nextId = 1;

  @override
  Future<AppUser> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final user = _usersByEmail[email.trim().toLowerCase()];
    if (user == null) {
      throw AuthException('No existe una cuenta con ese correo. Regístrate primero.');
    }
    return user;
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String documentId,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final normalizedEmail = email.trim().toLowerCase();
    if (_usersByEmail.containsKey(normalizedEmail)) {
      throw AuthException('Ya existe una cuenta con ese correo.');
    }
    final user = AppUser(
      id: (_nextId++).toString(),
      fullName: fullName.trim(),
      documentId: documentId.trim(),
      email: normalizedEmail,
    );
    _usersByEmail[normalizedEmail] = user;
    return user;
  }
}
