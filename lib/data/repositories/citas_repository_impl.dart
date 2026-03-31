import '../../core/errors/exceptions.dart';
import '../../core/utils/token_storage.dart';
import '../../domain/entities/cita.dart';
import '../../domain/repositories/citas_repository.dart';
import '../datasources/citas_datasource.dart';

class CitasRepositoryImpl implements CitasRepository {
  final CitasDatasource _datasource;

  CitasRepositoryImpl(this._datasource);

  Future<String> _getToken() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw const UnauthorizedException('Sin sesión activa');
    return token;
  }

  @override
  Future<List<Cita>> getCitas() async {
    return _datasource.getCitas(await _getToken());
  }

  @override
  Future<void> cambiarEstado({
    required int idCita,
    required int idEstado,
  }) async {
    await _datasource.cambiarEstado(
      token: await _getToken(),
      idCita: idCita,
      idEstado: idEstado,
    );
  }
}
