import '../entities/usuario.dart';

// Interfaz abstracta del repositorio de autenticación
abstract class AuthRepository {
  Future<({Usuario usuario, String token})> login({
    required String correo,
    required String clave,
  });

  Future<void> logout();
}
