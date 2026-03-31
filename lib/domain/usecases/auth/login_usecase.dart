import '../../entities/usuario.dart';
import '../../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<({Usuario usuario, String token})> call({
    required String correo,
    required String clave,
  }) {
    return _repository.login(correo: correo, clave: clave);
  }
}
