import 'package:flutter/foundation.dart';

import '../../../../core/network/app_error_mapper.dart';
import '../../data/models/auth_session.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  AuthSession? _session;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  AuthSession? get session => _session;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _session != null;
  String? get errorMessage => _errorMessage;

  Future<void> restoreSession() async {
    _session = _authRepository.getSavedSession();
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _session = await _authRepository.login(email: email, password: password);
      return true;
    } catch (error) {
      _errorMessage = _parseError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      return true;
    } catch (error) {
      _errorMessage = _parseError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _session = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _parseError(Object error) {
    return AppErrorMapper.toCode(error);
  }
}
