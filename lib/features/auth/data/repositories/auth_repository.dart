import '../../../../core/storage/session_storage.dart';
import '../models/auth_session.dart';
import '../services/auth_api_service.dart';

class AuthRepository {
  AuthRepository({
    required AuthApiService authApiService,
    required SessionStorage sessionStorage,
  }) : _authApiService = authApiService,
       _sessionStorage = sessionStorage;

  final AuthApiService _authApiService;
  final SessionStorage _sessionStorage;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _authApiService.register(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final AuthSession session = await _authApiService.login(
      email: email,
      password: password,
    );

    await _sessionStorage.saveSession(
      token: session.token,
      userId: session.userId,
      name: session.name,
    );

    return session;
  }

  AuthSession? getSavedSession() {
    final String? token = _sessionStorage.token;
    if (token == null || token.isEmpty) {
      return null;
    }

    return AuthSession(
      token: token,
      userId: _sessionStorage.userId ?? '',
      name: _sessionStorage.name ?? '',
    );
  }

  Future<void> logout() => _sessionStorage.clearSession();
}
