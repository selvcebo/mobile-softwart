import 'package:flutter/material.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;

  AuthProvider({
    required LoginUsecase loginUsecase,
    required LogoutUsecase logoutUsecase,
  })  : _loginUsecase = loginUsecase,
        _logoutUsecase = logoutUsecase;

  AuthStatus _status = AuthStatus.initial;
  Usuario? _usuario;
  String? _token;
  String? _error;

  AuthStatus get status => _status;
  Usuario? get usuario => _usuario;
  String? get token => _token;
  String? get error => _error;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Llamado desde main.dart al arrancar la app
  void setAuthenticated({required Usuario usuario, required String token}) {
    _usuario = usuario;
    _token = token;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void setUnauthenticated() {
    _usuario = null;
    _token = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> login({required String correo, required String clave}) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final result = await _loginUsecase(correo: correo, clave: clave);
      _usuario = result.usuario;
      _token = result.token;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _logoutUsecase();
    _usuario = null;
    _token = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
