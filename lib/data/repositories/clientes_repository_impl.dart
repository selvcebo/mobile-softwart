import '../../core/errors/exceptions.dart';
import '../../core/utils/token_storage.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/clientes_repository.dart';
import '../datasources/clientes_datasource.dart';

class ClientesRepositoryImpl implements ClientesRepository {
  final ClientesDatasource _datasource;

  ClientesRepositoryImpl(this._datasource);

  Future<String> _getToken() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw const UnauthorizedException('Sin sesión activa');
    return token;
  }

  @override
  Future<List<Cliente>> getClientes() async {
    return _datasource.getClientes(await _getToken());
  }
}
