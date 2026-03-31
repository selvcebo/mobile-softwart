import '../../core/utils/token_storage.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

// Implementación concreta del repositorio de auth
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
      : _datasource = datasource ?? AuthDatasource();

  @override
  Future<({Usuario usuario, String token})> login({
    required String correo,
    required String clave,
  }) async {
    final result = await _datasource.login(correo: correo, clave: clave);
    await TokenStorage.saveToken(result.token);
    return (usuario: result.usuario, token: result.token);
  }

  @override
  Future<void> logout() async {
    await TokenStorage.deleteToken();
  }
}
